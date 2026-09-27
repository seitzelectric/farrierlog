import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import 'client_form_dialog.dart';
import 'new_visit_screen.dart';

/// Preview/mapping screen for events parsed from an `.ics` file. Pops with
/// the number of visits imported (or null if the user backed out).
class ImportCalendarScreen extends StatefulWidget {
  final List<IcsEvent> events;

  const ImportCalendarScreen({super.key, required this.events});

  /// Above this many events, the list is limited to a date range (defaulting
  /// to today onward) so the user isn't scrolling through years of history.
  static const largeFileThreshold = 500;

  @override
  State<ImportCalendarScreen> createState() => _ImportCalendarScreenState();
}

enum _PickAction { createNew, skip }

class _ImportRow {
  final IcsEvent event;
  bool selected = true;
  Client? client;
  bool duplicate = false;

  _ImportRow(this.event);
}

class _ImportCalendarScreenState extends State<ImportCalendarScreen> {
  List<Client> _clients = [];
  late final List<_ImportRow> _rows;
  DateTimeRange? _range;
  bool _loading = true;
  bool _importing = false;

  bool get _isLargeFile =>
      widget.events.length > ImportCalendarScreen.largeFileThreshold;

  List<_ImportRow> get _visibleRows {
    final range = _range;
    if (range == null) return _rows;
    final end = range.end.add(const Duration(days: 1));
    return _rows
        .where((r) =>
            !r.event.startDateTime.isBefore(range.start) &&
            r.event.startDateTime.isBefore(end))
        .toList();
  }

  List<_ImportRow> get _rowsToImport =>
      _visibleRows.where((r) => r.selected && r.client != null).toList();

  @override
  void initState() {
    super.initState();
    _rows = widget.events.map(_ImportRow.new).toList();
    if (_isLargeFile) {
      final today = DateUtils.dateOnly(DateTime.now());
      final first = DateUtils.dateOnly(widget.events.first.startDateTime);
      final last = DateUtils.dateOnly(widget.events.last.startDateTime);
      // Default to upcoming events; fall back to everything if the whole
      // file is in the past.
      _range = DateTimeRange(
        start: last.isBefore(today) || first.isAfter(today) ? first : today,
        end: last,
      );
    }
    _loadData();
  }

  Future<void> _loadData() async {
    _clients = await DatabaseService.getClients();
    for (final row in _rows) {
      row.client = _matchClient(row.event);
      await _refreshDuplicate(row);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _refreshDuplicate(_ImportRow row) async {
    final client = row.client;
    row.duplicate = client != null &&
        await DatabaseService.visitExistsAt(
            client.id!, row.event.startDateTime);
  }

  // ==================== CLIENT MATCHING ====================

  /// Suggests a client whose name appears in the event summary, or whose
  /// address matches the event location. Returns null when there is no
  /// match or the best match is ambiguous.
  Client? _matchClient(IcsEvent event) {
    var bestScore = 0;
    final best = <Client>[];
    for (final client in _clients) {
      final score = _matchScore(client, event);
      if (score == 0) continue;
      if (score > bestScore) {
        bestScore = score;
        best
          ..clear()
          ..add(client);
      } else if (score == bestScore) {
        best.add(client);
      }
    }
    return best.length == 1 ? best.first : null;
  }

  static int _matchScore(Client client, IcsEvent event) {
    var score = 0;
    final summary = event.summary.toLowerCase();
    final fullName = '${client.firstName} ${client.lastName}'.trim();
    if (fullName.contains(' ') && _containsWord(summary, fullName)) {
      score += 4;
    } else if (_containsWord(summary, client.lastName)) {
      score += 2;
    } else if (_containsWord(summary, client.firstName)) {
      score += 1;
    }

    final location = _normalizeAddress(event.location);
    final address = _normalizeAddress(client.address);
    if (location.isNotEmpty && address.isNotEmpty) {
      if (location == address ||
          location.contains(address) ||
          address.contains(location)) {
        score += 4;
      } else if (_street(location) == _street(address)) {
        score += 3;
      }
    }
    return score;
  }

  static bool _containsWord(String haystack, String word) {
    final w = word.trim().toLowerCase();
    if (w.length < 2) return false;
    return RegExp('\\b${RegExp.escape(w)}\\b').hasMatch(haystack);
  }

  static String _normalizeAddress(String address) => address
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s,]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  /// The part of an address before the first comma (e.g. "123 farm rd").
  static String _street(String normalized) =>
      normalized.split(',').first.trim();

  // ==================== ACTIONS ====================

  Future<void> _pickClient(_ImportRow row) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<Object>(
      context: context,
      builder: (ctx) => ClientSearchDialog(
        clients: _clients,
        extraOptions: [
          ListTile(
            leading: const Icon(Icons.person_add_alt),
            title: Text(l10n.importCreateNewClient),
            onTap: () => Navigator.of(ctx).pop(_PickAction.createNew),
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: Text(l10n.importSkipNoClient),
            onTap: () => Navigator.of(ctx).pop(_PickAction.skip),
          ),
        ],
      ),
    );
    if (result == null) return;

    Client? client;
    if (result is Client) {
      client = result;
    } else if (result == _PickAction.createNew) {
      client = await _createClientFrom(row.event);
      if (client == null) return;
    }
    row.client = client;
    await _refreshDuplicate(row);
    if (mounted) setState(() {});
  }

  Future<Client?> _createClientFrom(IcsEvent event) async {
    final draft = await showDialog<Client>(
      context: context,
      builder: (_) => ClientFormDialog(
        prefill: Client(
          firstName: '',
          lastName: event.summary,
          phone: '',
          email: '',
          address: event.location,
          notes: '',
        ),
      ),
    );
    if (draft == null) return null;
    final id = await DatabaseService.insertClient(draft);
    final client = await DatabaseService.getClient(id);
    if (client != null) _clients = await DatabaseService.getClients();
    return client;
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateUtils.dateOnly(widget.events.first.startDateTime),
      lastDate: DateUtils.dateOnly(widget.events.last.startDateTime),
      initialDateRange: _range,
    );
    if (picked != null) setState(() => _range = picked);
  }

  void _setAllSelected(bool selected) {
    setState(() {
      for (final row in _visibleRows) {
        row.selected = selected;
      }
    });
  }

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context)!;
    final rows = _rowsToImport;
    if (rows.isEmpty) return;

    final duplicates = rows.where((r) => r.duplicate).length;
    if (duplicates > 0) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.importDuplicatesTitle),
          content: Text(l10n.importDuplicatesMessage(duplicates)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.importAnywayButton),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    setState(() => _importing = true);
    for (final row in rows) {
      final event = row.event;
      final notes = [event.summary, event.description]
          .where((s) => s.isNotEmpty)
          .join('\n\n');
      await DatabaseService.insertVisit(
        Visit(
          clientId: row.client!.id!,
          clientName: row.client!.fullName,
          dateTime: event.startDateTime,
          notes: notes,
          paid: false,
          completed: false,
          recurrenceWeeks: event.recurrenceWeeks,
        ),
        const [],
      );
    }
    if (mounted) Navigator.pop(context, rows.length);
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.importCalendarTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final visible = _visibleRows;
    final allSelected = visible.isNotEmpty && visible.every((r) => r.selected);
    final importCount = _rowsToImport.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importCalendarTitle),
        actions: [
          if (_isLargeFile)
            IconButton(
              onPressed: _pickRange,
              icon: const Icon(Icons.date_range),
              tooltip: l10n.importFilterByDate,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_range != null)
            ListTile(
              dense: true,
              leading: const Icon(Icons.filter_alt_outlined),
              title: Text(
                  l10n.importFilteredCount(visible.length, _rows.length)),
              subtitle: Text(
                  '${AppUtils.formatDate(_range!.start)} – ${AppUtils.formatDate(_range!.end)}'),
              onTap: _pickRange,
            ),
          CheckboxListTile(
            value: allSelected,
            onChanged: visible.isEmpty
                ? null
                : (v) => _setAllSelected(v ?? false),
            title: Text(
                allSelected ? l10n.importDeselectAll : l10n.importSelectAll),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(height: 1),
          Expanded(
            child: visible.isEmpty
                ? Center(child: Text(l10n.importNoEventsInRange))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: visible.length,
                    itemBuilder: (ctx, i) => _buildRow(visible[i], l10n),
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.icon(
                onPressed:
                    importCount == 0 || _importing ? null : _import,
                icon: _importing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(l10n.importSelectedButton(importCount)),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(_ImportRow row, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final event = row.event;
    final when = event.isAllDay
        ? '${AppUtils.formatDate(event.startDateTime)} · ${l10n.importAllDay}'
        : '${AppUtils.formatDate(event.startDateTime)} · ${AppUtils.formatTime(event.startDateTime)}';
    final warningStyle =
        theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: row.selected,
              onChanged: (v) => setState(() => row.selected = v ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(when, style: theme.textTheme.labelMedium),
                  if (event.summary.isNotEmpty)
                    Text(event.summary, style: theme.textTheme.titleMedium),
                  if (event.location.isNotEmpty)
                    Text(event.location, style: theme.textTheme.bodySmall),
                  if (event.description.isNotEmpty)
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  if (event.isRecurring)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            event.hasUnsupportedRecurrence
                                ? Icons.event_busy
                                : Icons.repeat,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.hasUnsupportedRecurrence
                                  ? l10n.importRecurrenceUnsupported
                                  : l10n.importRecurrenceWeeks(
                                      event.recurrenceWeeks!),
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: row.selected ? () => _pickClient(row) : null,
                    child: InputDecorator(
                      isEmpty: false,
                      decoration: InputDecoration(
                        labelText: l10n.clientDropdownLabel,
                        enabled: row.selected,
                        isDense: true,
                        suffixIcon: const Icon(Icons.search),
                      ),
                      child: Text(
                        row.client?.fullName ?? l10n.importSkipNoClient,
                        style: row.client == null
                            ? theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.hintColor)
                            : null,
                      ),
                    ),
                  ),
                  if (row.duplicate)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              size: 16, color: theme.colorScheme.error),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(l10n.importDuplicateWarning,
                                style: warningStyle),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
