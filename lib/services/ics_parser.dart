import '../models/models.dart';

/// Minimal pure-Dart parser for iCalendar (`.ics`) files, covering what
/// Google Calendar's export produces. Only VEVENT components are read.
class IcsParser {
  /// Hour assigned to all-day events, which have no time of their own.
  static const allDayDefaultHour = 8;

  static List<IcsEvent> parse(String text) {
    final events = <IcsEvent>[];
    final seen = <String>{};

    Map<String, _IcsProperty>? current;
    // Depth of nested components inside the current VEVENT (e.g. VALARM),
    // whose properties must not overwrite the event's own.
    var nested = 0;

    for (final line in _unfold(text)) {
      final prop = _IcsProperty.parse(line);
      if (prop == null) continue;

      if (prop.name == 'BEGIN') {
        if (current != null) {
          nested++;
        } else if (prop.value.toUpperCase() == 'VEVENT') {
          current = {};
        }
        continue;
      }

      if (prop.name == 'END') {
        if (current == null) continue;
        if (nested > 0) {
          nested--;
          continue;
        }
        final event = _buildEvent(current);
        current = null;
        if (event == null) continue;
        // Recurring exports can repeat the same instance; keep the first.
        final key = '${event.uid}|${event.startDateTime.toIso8601String()}';
        if (seen.add(key)) events.add(event);
        continue;
      }

      if (current == null || nested > 0) continue;
      current.putIfAbsent(prop.name, () => prop);
    }

    events.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    return events;
  }

  static IcsEvent? _buildEvent(Map<String, _IcsProperty> props) {
    if (props['STATUS']?.value.toUpperCase() == 'CANCELLED') return null;
    final startProp = props['DTSTART'];
    if (startProp == null) return null;
    final start = _parseDate(startProp);
    if (start == null) return null;
    final endProp = props['DTEND'];
    final end = endProp == null || start.allDay ? null : _parseDate(endProp);
    final rrule = props['RRULE']?.value.trim();

    return IcsEvent(
      uid: props['UID']?.value.trim() ?? '',
      summary: _unescape(props['SUMMARY']?.value ?? '').trim(),
      startDateTime: start.dateTime,
      endDateTime: end?.dateTime,
      location: _unescape(props['LOCATION']?.value ?? '').trim(),
      description: _unescape(props['DESCRIPTION']?.value ?? '').trim(),
      isAllDay: start.allDay,
      isRecurring: rrule != null,
      recurrenceWeeks:
          rrule == null ? null : _recurrenceWeeks(rrule, start.dateTime),
    );
  }

  static const _weekdayCodes = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

  /// Maps `FREQ=WEEKLY;INTERVAL=n` to n weeks and `FREQ=MONTHLY` to 4 weeks
  /// per month of interval. Returns null for any other frequency or for rules
  /// with BY* parts, except the BYDAY/BYMONTHDAY that just restate DTSTART's
  /// own weekday/day (Google adds these to every weekly/monthly event).
  /// COUNT and UNTIL are ignored: FarrierLog recurrence chains have no end.
  static int? _recurrenceWeeks(String rule, DateTime start) {
    final parts = <String, String>{};
    for (final part in rule.split(';')) {
      final eq = part.indexOf('=');
      if (eq <= 0) continue;
      parts[part.substring(0, eq).toUpperCase()] =
          part.substring(eq + 1).toUpperCase();
    }
    final freq = parts['FREQ'];
    final interval = int.tryParse(parts['INTERVAL'] ?? '1');
    if (interval == null || interval <= 0) return null;

    for (final MapEntry(:key, :value) in parts.entries) {
      if (const {'FREQ', 'INTERVAL', 'COUNT', 'UNTIL', 'WKST'}.contains(key)) {
        continue;
      }
      final redundant = switch (key) {
        'BYDAY' => freq == 'WEEKLY' && value == _weekdayCodes[start.weekday - 1],
        'BYMONTHDAY' => freq == 'MONTHLY' && value == '${start.day}',
        _ => false,
      };
      if (!redundant) return null;
    }

    return switch (freq) {
      'WEEKLY' => interval,
      'MONTHLY' => 4 * interval,
      _ => null,
    };
  }

  /// Parses `YYYYMMDD`, `YYYYMMDDTHHmmss` and `YYYYMMDDTHHmmssZ`. UTC values
  /// are converted to local time. TZID-qualified values are treated as local
  /// wall-clock time (no timezone database is bundled).
  static ({DateTime dateTime, bool allDay})? _parseDate(_IcsProperty prop) {
    final value = prop.value.trim();
    final match =
        RegExp(r'^(\d{4})(\d{2})(\d{2})(?:T(\d{2})(\d{2})(\d{2})?(Z)?)?$')
            .firstMatch(value);
    if (match == null) return null;
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);

    final allDay = match.group(4) == null ||
        prop.params['VALUE']?.toUpperCase() == 'DATE';
    if (allDay) {
      return (
        dateTime: DateTime(year, month, day, allDayDefaultHour),
        allDay: true,
      );
    }

    final hour = int.parse(match.group(4)!);
    final minute = int.parse(match.group(5)!);
    final second = int.parse(match.group(6) ?? '0');
    final dateTime = match.group(7) != null
        ? DateTime.utc(year, month, day, hour, minute, second).toLocal()
        : DateTime(year, month, day, hour, minute, second);
    return (dateTime: dateTime, allDay: false);
  }

  /// Joins folded lines: a line starting with a space or tab continues the
  /// previous one (RFC 5545 §3.1).
  static List<String> _unfold(String text) {
    final lines = <String>[];
    for (final raw in text.split(RegExp(r'\r\n|\n|\r'))) {
      if (raw.isEmpty) continue;
      if ((raw.startsWith(' ') || raw.startsWith('\t')) && lines.isNotEmpty) {
        lines[lines.length - 1] += raw.substring(1);
      } else {
        lines.add(raw);
      }
    }
    return lines;
  }

  static String _unescape(String value) => value.replaceAllMapped(
        RegExp(r'\\([\;,nN])'),
        (m) => switch (m.group(1)!) {
          'n' || 'N' => '\n',
          final c => c,
        },
      );
}

class _IcsProperty {
  final String name;
  final Map<String, String> params;
  final String value;

  _IcsProperty(this.name, this.params, this.value);

  /// Splits `NAME;PARAM=x;PARAM2="a:b":value` at the first colon outside
  /// quotes.
  static _IcsProperty? parse(String line) {
    var inQuotes = false;
    var colon = -1;
    for (var i = 0; i < line.length; i++) {
      final c = line[i];
      if (c == '"') inQuotes = !inQuotes;
      if (c == ':' && !inQuotes) {
        colon = i;
        break;
      }
    }
    if (colon <= 0) return null;

    final head = line.substring(0, colon).split(';');
    final params = <String, String>{};
    for (final p in head.skip(1)) {
      final eq = p.indexOf('=');
      if (eq <= 0) continue;
      params[p.substring(0, eq).toUpperCase()] =
          p.substring(eq + 1).replaceAll('"', '');
    }
    return _IcsProperty(
        head.first.toUpperCase(), params, line.substring(colon + 1));
  }
}
