import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class NewVisitScreen extends StatefulWidget {
  final Client? client;
  final Visit? visit;
  final DateTime? initialDateTime;

  const NewVisitScreen({
    super.key,
    this.client,
    this.visit,
    this.initialDateTime,
  });

  @override
  State<NewVisitScreen> createState() => _NewVisitScreenState();
}

class _NewVisitScreenState extends State<NewVisitScreen> {
  final _notesCtrl = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  List<Client> _clients = [];
  Client? _selectedClient;
  List<Horse> _horses = [];
  final Set<int> _selectedHorseIds = {};
  int? _recurrenceWeeks;
  final _customWeeksCtrl = TextEditingController();
  bool _loading = true;
  bool _showClientError = false;
  bool _startWeekOnMonday = false;
  bool get _isEditing => widget.visit != null;
  bool get _isCustomRecurrence =>
      _recurrenceWeeks != null && ![4, 6, 8, 10].contains(_recurrenceWeeks);

  @override
  void initState() {
    super.initState();
    _selectedClient = widget.client;
    _selectedDateTime =
        widget.visit?.dateTime ?? widget.initialDateTime ?? DateTime.now();
    final visit = widget.visit;
    if (visit != null) {
      _notesCtrl.text = visit.notes;
      _recurrenceWeeks = visit.recurrenceWeeks;
      if (_isCustomRecurrence) {
        _customWeeksCtrl.text = _recurrenceWeeks.toString();
      }
    }
    _loadData();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _customWeeksCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final clients = await DatabaseService.getClients();
    final startOnMonday =
        await DatabaseService.getSetting('start_calendar_week_on_monday') ==
            'true';
    if (_selectedClient == null && widget.visit != null) {
      _selectedClient = await DatabaseService.getClient(widget.visit!.clientId);
    }
    if (_selectedClient != null) {
      _horses = await DatabaseService.getHorsesForClient(_selectedClient!.id!);
    }
    if (widget.visit?.id != null) {
      final selectedHorses =
          await DatabaseService.getHorsesForVisit(widget.visit!.id!);
      _selectedHorseIds
        ..clear()
        ..addAll(selectedHorses.map((h) => h.id!).whereType<int>());
    }
    if (mounted) {
      setState(() {
        _clients = clients;
        _startWeekOnMonday = startOnMonday;
        _loading = false;
      });
    }
  }

  Future<void> _onClientChanged(Client? client) async {
    setState(() {
      _selectedClient = client;
      _selectedHorseIds.clear();
    });
    if (client != null) {
      _horses = await DatabaseService.getHorsesForClient(client.id!);
      if (mounted) setState(() {});
    }
  }

  Future<void> _pickClient() async {
    final selected = await showDialog<Client>(
      context: context,
      builder: (ctx) => _ClientSearchDialog(clients: _clients),
    );
    if (selected != null) {
      await _onClientChanged(selected);
      if (mounted) setState(() => _showClientError = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      // Mirror the calendar screen's start-of-week preference.
      locale: _startWeekOnMonday
          ? const Locale('en', 'GB') // Monday-first locale
          : const Locale('en', 'US'), // Sunday-first locale
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(picked.year, picked.month, picked.day,
            _selectedDateTime.hour, _selectedDateTime.minute);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
            _selectedDateTime.year,
            _selectedDateTime.month,
            _selectedDateTime.day,
            picked.hour,
            picked.minute);
      });
    }
  }

  Future<void> _save() async {
    if (_selectedClient == null) {
      setState(() => _showClientError = true);
      return;
    }

    final recurrenceWeeks = _resolvedRecurrenceWeeks();
    if (recurrenceWeeks != null && recurrenceWeeks <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom weeks must be greater than 0')),
      );
      return;
    }

    final visit = Visit(
      id: widget.visit?.id,
      clientId: _selectedClient!.id!,
      clientName: _selectedClient!.fullName,
      dateTime: _selectedDateTime,
      notes: _notesCtrl.text.trim(),
      paid: widget.visit?.paid ?? false,
      completed: widget.visit?.completed ?? false,
      recurrenceWeeks: recurrenceWeeks,
      nextRecurringVisitId: widget.visit?.nextRecurringVisitId,
      isAutoGenerated: widget.visit?.isAutoGenerated ?? false,
      createdAt: widget.visit?.createdAt,
    );

    final visitId = _isEditing
        ? await DatabaseService.updateVisit(visit, _selectedHorseIds.toList())
        : await DatabaseService.insertVisit(visit, _selectedHorseIds.toList());

    final savedVisit = Visit(
      id: visitId,
      clientId: visit.clientId,
      clientName: visit.clientName,
      dateTime: visit.dateTime,
      notes: visit.notes,
      paid: visit.paid,
      completed: visit.completed,
      recurrenceWeeks: visit.recurrenceWeeks,
      nextRecurringVisitId: visit.nextRecurringVisitId,
      isAutoGenerated: visit.isAutoGenerated,
      createdAt: visit.createdAt,
    );
    await DatabaseService.generateRecurringChain(savedVisit, weeksAhead: 10);

    final created = await DatabaseService.getVisit(visitId);
    if (!mounted || created == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => VisitDetailScreen(visit: created)),
    );
  }

  int? _resolvedRecurrenceWeeks() {
    if (!_isCustomRecurrence) return _recurrenceWeeks;
    return int.tryParse(_customWeeksCtrl.text.trim());
  }

  void _onRecurrenceChanged(int? value) {
    setState(() {
      _recurrenceWeeks = value;
      if (!_isCustomRecurrence) _customWeeksCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Edit Visit' : 'New Visit')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Visit' : 'New Visit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.client == null)
            InkWell(
              onTap: _pickClient,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Client',
                  errorText:
                      _showClientError ? 'Please select a client' : null,
                  suffixIcon: const Icon(Icons.search),
                ),
                child: Text(
                  _selectedClient?.fullName ?? 'Search for a client...',
                  style: _selectedClient == null
                      ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          )
                      : null,
                ),
              ),
            )
          else
            ListTile(
              leading: ClientAvatar(client: _selectedClient!),
              title: Text(_selectedClient!.fullName),
              subtitle: Text(_selectedClient!.address),
            ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date'),
            subtitle: Text(AppUtils.formatDate(_selectedDateTime)),
            onTap: _pickDate,
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Time'),
            subtitle: Text(AppUtils.formatTime(_selectedDateTime)),
            onTap: _pickTime,
          ),
          DropdownButtonFormField<int?>(
            value: _isCustomRecurrence ? -1 : _recurrenceWeeks,
            decoration: const InputDecoration(labelText: 'Recurring'),
            items: const [
              DropdownMenuItem<int?>(value: null, child: Text('None')),
              DropdownMenuItem<int?>(value: 4, child: Text('Every 4 weeks')),
              DropdownMenuItem<int?>(value: 6, child: Text('Every 6 weeks')),
              DropdownMenuItem<int?>(value: 8, child: Text('Every 8 weeks')),
              DropdownMenuItem<int?>(value: 10, child: Text('Every 10 weeks')),
              DropdownMenuItem<int?>(value: -1, child: Text('Custom weeks')),
            ],
            onChanged: (value) {
              if (value == -1) {
                if (_customWeeksCtrl.text.trim().isEmpty) {
                  _customWeeksCtrl.text = '1';
                }
                _onRecurrenceChanged(
                  int.tryParse(_customWeeksCtrl.text.trim()) ?? 1,
                );
              } else {
                _onRecurrenceChanged(value);
              }
            },
          ),
          if (_isCustomRecurrence) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _customWeeksCtrl,
              decoration: const InputDecoration(
                labelText: 'Custom weeks',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final weeks = int.tryParse(value.trim());
                if (weeks != null) _recurrenceWeeks = weeks;
              },
            ),
          ],
          const SizedBox(height: 8),
          if (_selectedClient != null) ...[
            Text('Select Animals',
                style: Theme.of(context).textTheme.titleMedium),
            if (_horses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('No animals for this client'),
              )
            else
              ..._horses.map((h) => CheckboxListTile(
                    value: _selectedHorseIds.contains(h.id),
                    title: Text(h.name),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedHorseIds.add(h.id!);
                        } else {
                          _selectedHorseIds.remove(h.id!);
                        }
                      });
                    },
                  )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "Don't need to track individual animals for this stop? "
                'Add a group service line from the visit screen after saving.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesCtrl,
            decoration: const InputDecoration(
              labelText: 'Visit Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(_isEditing ? 'Update Visit' : 'Save Visit'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientSearchDialog extends StatefulWidget {
  const _ClientSearchDialog({required this.clients});
  final List<Client> clients;

  @override
  State<_ClientSearchDialog> createState() => _ClientSearchDialogState();
}

class _ClientSearchDialogState extends State<_ClientSearchDialog> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Client> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.clients;
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filtered = query.isEmpty
          ? widget.clients
          : widget.clients
              .where((c) =>
                  c.fullName.toLowerCase().contains(query) ||
                  c.address.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search clients...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No clients found'))
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) {
                      final client = _filtered[i];
                      return ListTile(
                        title: Text(client.fullName),
                        subtitle: Text(client.address),
                        onTap: () => Navigator.of(ctx).pop(client),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
