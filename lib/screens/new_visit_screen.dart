import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class NewVisitScreen extends StatefulWidget {
  final Client? client;

  const NewVisitScreen({super.key, this.client});

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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedClient = widget.client;
    _loadData();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final clients = await DatabaseService.getClients();
    if (_selectedClient != null) {
      _horses = await DatabaseService.getHorsesForClient(_selectedClient!.id!);
    }
    if (mounted) {
      setState(() {
        _clients = clients;
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
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
        _selectedDateTime = DateTime(_selectedDateTime.year,
            _selectedDateTime.month, _selectedDateTime.day, picked.hour, picked.minute);
      });
    }
  }

  Future<void> _save() async {
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client')),
      );
      return;
    }

    final visit = Visit(
      clientId: _selectedClient!.id!,
      clientName: _selectedClient!.fullName,
      dateTime: _selectedDateTime,
      notes: _notesCtrl.text.trim(),
      paid: false,
    );

    final visitId = await DatabaseService.insertVisit(
      visit,
      _selectedHorseIds.toList(),
    );

    try {
  final event = Event(
    title: 'Farrier - ${_selectedClient!.fullName}',
    description: _notesCtrl.text.trim().isEmpty
        ? 'Farrier visit'
        : _notesCtrl.text.trim(),
    location: _selectedClient!.address,
    startDate: _selectedDateTime,
    endDate: _selectedDateTime.add(const Duration(hours: 1)),
  );

  await Add2Calendar.addEvent2Cal(event);
} catch (e) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Calendar event was not added: $e')),
  );
}

    if (mounted) {
      final created = await DatabaseService.getVisit(visitId);
      if (created != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VisitDetailScreen(visit: created)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('New Visit')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New Visit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.client == null)
            DropdownButtonFormField<Client>(
              value: _selectedClient,
              decoration: const InputDecoration(labelText: 'Client'),
              isExpanded: true,
              items: _clients.map((c) {
                return DropdownMenuItem<Client>(
                  value: c,
                  child: Text(c.fullName),
                );
              }).toList(),
              onChanged: _onClientChanged,
              validator: (v) => v == null ? 'Please select a client' : null,
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
          const SizedBox(height: 8),
          if (_selectedClient != null) ...[
            Text('Select Horses', style: Theme.of(context).textTheme.titleMedium),
            if (_horses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('No horses for this client'),
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
            label: const Text('Save Visit'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

