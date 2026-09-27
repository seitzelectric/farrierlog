import 'package:flutter_test/flutter_test.dart';
import 'package:farrier_log/models/models.dart';
import 'package:farrier_log/services/ics_parser.dart';

String _ics(String body) =>
    'BEGIN:VCALENDAR\r\nVERSION:2.0\r\n$body\r\nEND:VCALENDAR\r\n';

void main() {
  test('parses a basic VEVENT', () {
    final events = IcsParser.parse(_ics('''
BEGIN:VEVENT
DTSTART:20260915T090000
DTEND:20260915T100000
SUMMARY:Trim - Johnson Ranch
LOCATION:123 Farm Rd\\, Springfield MO
DESCRIPTION:4 horses\\nfront trim only
UID:abc123@google.com
END:VEVENT'''));

    expect(events, hasLength(1));
    final e = events.single;
    expect(e.uid, 'abc123@google.com');
    expect(e.summary, 'Trim - Johnson Ranch');
    expect(e.startDateTime, DateTime(2026, 9, 15, 9));
    expect(e.endDateTime, DateTime(2026, 9, 15, 10));
    expect(e.location, '123 Farm Rd, Springfield MO');
    expect(e.description, '4 horses\nfront trim only');
    expect(e.isAllDay, isFalse);
    expect(e.isRecurring, isFalse);
  });

  test('converts UTC times to local', () {
    final events = IcsParser.parse(_ics(
        'BEGIN:VEVENT\r\nUID:x\r\nDTSTART:20260915T150000Z\r\nEND:VEVENT'));
    expect(events.single.startDateTime,
        DateTime.utc(2026, 9, 15, 15).toLocal());
  });

  test('all-day events default to 8:00 AM', () {
    final events = IcsParser.parse(_ics('''
BEGIN:VEVENT
UID:a
DTSTART;VALUE=DATE:20261001
DTEND;VALUE=DATE:20261002
END:VEVENT'''));
    expect(events.single.startDateTime, DateTime(2026, 10, 1, 8));
    expect(events.single.isAllDay, isTrue);
    expect(events.single.endDateTime, isNull);
  });

  test('treats TZID times as local wall-clock time', () {
    final events = IcsParser.parse(_ics(
        'BEGIN:VEVENT\r\nUID:t\r\nDTSTART;TZID="America/Chicago":20261001T133000\r\nEND:VEVENT'));
    expect(events.single.startDateTime, DateTime(2026, 10, 1, 13, 30));
  });

  test('unfolds continuation lines', () {
    final events = IcsParser.parse(_ics(
        'BEGIN:VEVENT\r\nUID:f\r\nDTSTART:20261001T090000\r\n'
        'DESCRIPTION:Shoe all four\r\n  and check the\r\n\tleft hind\r\nEND:VEVENT'));
    expect(events.single.description, 'Shoe all four and check theleft hind');
  });

  test('skips cancelled events, VTIMEZONE, and nested VALARM properties', () {
    final events = IcsParser.parse(_ics('''
BEGIN:VTIMEZONE
TZID:America/Chicago
BEGIN:STANDARD
DTSTART:19701101T020000
END:STANDARD
END:VTIMEZONE
BEGIN:VEVENT
UID:cancelled
DTSTART:20261001T090000
STATUS:CANCELLED
END:VEVENT
BEGIN:VEVENT
UID:kept
DTSTART:20261002T090000
SUMMARY:Kept
BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:This is an event reminder
END:VALARM
END:VEVENT'''));
    expect(events, hasLength(1));
    expect(events.single.uid, 'kept');
    expect(events.single.description, isEmpty);
  });

  test('deduplicates repeated instances and flags recurring events', () {
    const event = '''
BEGIN:VEVENT
UID:r1
DTSTART:20261001T090000
RRULE:FREQ=WEEKLY;INTERVAL=6
SUMMARY:Recurring
END:VEVENT''';
    final events = IcsParser.parse(_ics('$event\n$event\n'
        'BEGIN:VEVENT\nUID:r1\nRECURRENCE-ID:20261112T090000\n'
        'DTSTART:20261112T100000\nEND:VEVENT'));
    expect(events, hasLength(2));
    expect(events.first.isRecurring, isTrue);
    expect(events.last.startDateTime, DateTime(2026, 11, 12, 10));
  });

  test('returns events sorted and empty for files without events', () {
    expect(IcsParser.parse(''), isEmpty);
    expect(IcsParser.parse(_ics('')), isEmpty);
    final events = IcsParser.parse(_ics(
        'BEGIN:VEVENT\nUID:b\nDTSTART:20261005T090000\nEND:VEVENT\n'
        'BEGIN:VEVENT\nUID:a\nDTSTART:20261001T090000\nEND:VEVENT'));
    expect(events.map((e) => e.uid), ['a', 'b']);
  });

  group('RRULE to recurrenceWeeks', () {
    // 2026-10-01 is a Thursday.
    IcsEvent parseRule(String rule) => IcsParser.parse(_ics(
            'BEGIN:VEVENT\nUID:r\nDTSTART:20261001T090000\nRRULE:$rule\nEND:VEVENT'))
        .single;

    test('weekly uses INTERVAL, defaulting to 1', () {
      expect(parseRule('FREQ=WEEKLY;INTERVAL=6').recurrenceWeeks, 6);
      expect(parseRule('FREQ=WEEKLY').recurrenceWeeks, 1);
    });

    test('monthly maps to 4 weeks per month', () {
      expect(parseRule('FREQ=MONTHLY').recurrenceWeeks, 4);
      expect(parseRule('FREQ=MONTHLY;INTERVAL=2').recurrenceWeeks, 8);
    });

    test('accepts BYDAY/BYMONTHDAY that restate DTSTART, plus COUNT/UNTIL', () {
      expect(parseRule('FREQ=WEEKLY;INTERVAL=5;BYDAY=TH;WKST=SU')
          .recurrenceWeeks, 5);
      expect(parseRule('FREQ=MONTHLY;BYMONTHDAY=1').recurrenceWeeks, 4);
      expect(parseRule('FREQ=WEEKLY;COUNT=10').recurrenceWeeks, 1);
      expect(parseRule('FREQ=WEEKLY;UNTIL=20271231T000000Z').recurrenceWeeks,
          1);
    });

    test('flags complex or other-frequency rules as unsupported', () {
      for (final rule in [
        'FREQ=WEEKLY;BYDAY=MO,TH',
        'FREQ=WEEKLY;BYDAY=FR',
        'FREQ=MONTHLY;BYDAY=1TH',
        'FREQ=MONTHLY;BYMONTHDAY=15',
        'FREQ=YEARLY;BYMONTH=10',
        'FREQ=DAILY',
      ]) {
        final e = parseRule(rule);
        expect(e.recurrenceWeeks, isNull, reason: rule);
        expect(e.hasUnsupportedRecurrence, isTrue, reason: rule);
      }
    });

    test('events without RRULE are not recurring', () {
      final e = IcsParser.parse(_ics(
              'BEGIN:VEVENT\nUID:o\nDTSTART:20261001T090000\nEND:VEVENT'))
          .single;
      expect(e.recurrenceWeeks, isNull);
      expect(e.hasUnsupportedRecurrence, isFalse);
    });
  });
}
