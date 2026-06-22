export 'visit_detail_screen.dart';
export 'client_form_dialog.dart';
export 'dashboard_screen.dart';
export 'dashboard_list_screen.dart';
export 'client_list_screen.dart';
export 'home_screen.dart';
export 'calendar_screen.dart';
export 'new_visit_screen.dart';
export 'horse_detail_screen.dart';
import 'new_visit_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../services/database_service.dart';
import '../widgets/widgets.dart';
import 'client_form_dialog.dart';
import 'visit_detail_screen.dart';

// ==================== CLIENT DETAIL SCREEN ====================

class ClientDetailScreen extends StatefulWidget {
  final Client client;
  const ClientDetailScreen({super.key, required this.client});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  late Client _client;
  List<Horse> _horses = [];
  List<Visit> _visits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _client = widget.client;
    _loadData();
  }

  Future<void> _loadData() async {
    final updatedClient = await DatabaseService.getClient(_client.id!);
    final horses = await DatabaseService.getHorsesForClient(_client.id!);
    final visits = await DatabaseService.getVisitsForClient(_client.id!);
    if (mounted) {
      setState(() {
        if (updatedClient != null) _client = updatedClient;
        _horses = horses;
        _visits = visits;
        _loading = false;
      });
    }
  }

  Future<void> _editClient() async {
    final result = await showDialog<Client>(
      context: context,
      builder: (_) => ClientFormDialog(client: _client),
    );
    if (result != null) {
      await DatabaseService.updateClient(result);
      _loadData();
    }
  }

  Future<void> _deleteClient() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Client',
      message:
          'Are you sure you want to delete ${_client.fullName}? This will also delete all associated visits, animals, and photos.',
    );
    if (confirmed == true) {
      await DatabaseService.deleteClient(_client.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _addHorseDialog() async {
    final result = await showDialog<Horse>(
      context: context,
      builder: (_) => HorseFormDialog(clientId: _client.id!),
    );
    if (result != null) {
      await DatabaseService.insertHorse(result);
      _loadData();
    }
  }

  Future<void> _editHorse(Horse horse) async {
    final result = await showDialog<Horse>(
      context: context,
      builder: (_) => HorseFormDialog(horse: horse),
    );
    if (result != null) {
      await DatabaseService.updateHorse(result);
      _loadData();
    }
  }

  Future<void> _deleteHorse(Horse horse) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Animal',
      message: 'Are you sure you want to delete ${horse.name}?',
    );
    if (confirmed == true) {
      await DatabaseService.deleteHorse(horse.id!);
      _loadData();
    }
  }

  Future<bool> _confirmDeleteHorse(Horse horse) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Animal',
      message: 'Are you sure you want to delete ${horse.name}?',
    );
    if (confirmed == true) {
      await DatabaseService.deleteHorse(horse.id!);
      await _loadData();
    }
    return false;
  }

  Future<bool> _confirmDeleteVisit(Visit visit) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Visit',
      message:
          'Delete the visit on ${AppUtils.formatDateTime(visit.dateTime)}?',
    );
    if (confirmed == true) {
      await DatabaseService.deleteVisit(visit.id!);
      await _loadData();
    }
    return false;
  }

  Future<void> _addVisit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewVisitScreen(client: _client),
      ),
    );
    _loadData();
  }

  Future<void> _openUri(String uri) async {
    final parsed = Uri.parse(uri);
    if (await canLaunchUrl(parsed)) {
      await launchUrl(parsed, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_client.fullName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') _editClient();
              if (value == 'delete') _deleteClient();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Client')),
              const PopupMenuItem(
                value: 'delete',
                child:
                    Text('Delete Client', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClientAvatar(client: _client, radius: 30),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_client.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    if (_client.address.isNotEmpty)
                                      Text(_client.address,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_client.phone.isNotEmpty)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.phone),
                              title: Text(_client.phone),
                              subtitle: const Text(
                                  'Tap to call • Long-press to text'),
                              onTap: () => _openUri('tel:${_client.phone}'),
                              onLongPress: () =>
                                  _openUri('sms:${_client.phone}'),
                            ),
                          if (_client.email.isNotEmpty)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.email),
                              title: Text(_client.email),
                              subtitle: const Text('Tap to email'),
                              onTap: () => _openUri('mailto:${_client.email}'),
                            ),
                          if (_client.address.isNotEmpty)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.map),
                              title: Text(_client.address),
                              subtitle: const Text('Open in maps'),
                              onTap: () => AppUtils.openGoogleMapsSearch(
                                _client.address,
                              ),
                            ),
                          if (_client.notes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Notes: ${_client.notes}'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: 'Animals (${_horses.length})',
                    onAdd: _addHorseDialog,
                    addLabel: 'Add Animal',
                  ),
                  if (_horses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No animals added yet'),
                    )
                  else
                    ..._horses.map((horse) => Dismissible(
                          key: ValueKey('horse-${horse.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (_) => _confirmDeleteHorse(horse),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: HorseAvatar(horse: horse, radius: 20),
                              title: Text(horse.name),
                              subtitle: horse.notes.isNotEmpty
                                  ? Text(horse.notes,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)
                                  : null,
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') _editHorse(horse);
                                  if (value == 'delete') _deleteHorse(horse);
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: 'Visits (${_visits.length})',
                    onAdd: _addVisit,
                    addLabel: 'New Visit',
                  ),
                  if (_visits.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No visits yet'),
                    )
                  else
                    ..._visits.map((visit) => Dismissible(
                          key: ValueKey('visit-${visit.id}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (_) => _confirmDeleteVisit(visit),
                          child: VisitListTile(
                            visit: visit,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      VisitDetailScreen(visit: visit),
                                ),
                              );
                              _loadData();
                            },
                          ),
                        )),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVisit,
        icon: const Icon(Icons.add),
        label: const Text('New Visit'),
      ),
    );
  }
}

// ==================== HORSE FORM DIALOG ====================

class HorseFormDialog extends StatefulWidget {
  final int? clientId;
  final Horse? horse;

  const HorseFormDialog({super.key, this.clientId, this.horse});

  @override
  State<HorseFormDialog> createState() => _HorseFormDialogState();
}

class _HorseFormDialogState extends State<HorseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _breedCtrl;
  late final TextEditingController _colorCtrl;
  late final TextEditingController _notesCtrl;

  bool get isEditing => widget.horse != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.horse?.name ?? '');
    _breedCtrl = TextEditingController(text: widget.horse?.breed ?? '');
    _colorCtrl = TextEditingController(text: widget.horse?.color ?? '');
    _notesCtrl = TextEditingController(text: widget.horse?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _colorCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Animal' : 'New Animal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Required' : null,
              ),
              TextFormField(
                controller: _breedCtrl,
                decoration: const InputDecoration(labelText: 'Species'),
              ),
              TextFormField(
                controller: _colorCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                Horse(
                  id: widget.horse?.id,
                  clientId: widget.clientId ?? widget.horse!.clientId,
                  name: _nameCtrl.text.trim(),
                  breed: _breedCtrl.text.trim(),
                  color: _colorCtrl.text.trim(),
                  notes: _notesCtrl.text.trim(),
                ),
              );
            }
          },
          child: Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}

// ==================== SERVICE LINE DIALOG ====================

class ServiceLineDialog extends StatefulWidget {
  final int visitId;
  final List<Horse> horses;
  final ServiceLine? serviceLine;

  const ServiceLineDialog({
    super.key,
    required this.visitId,
    required this.horses,
    this.serviceLine,
  });

  @override
  State<ServiceLineDialog> createState() => _ServiceLineDialogState();
}

class _ServiceLineDialogState extends State<ServiceLineDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _groupLabelCtrl;
  late final TextEditingController _quantityCtrl;
  int? _selectedHorseId;
  late bool _isGroup;

  bool get isEditing => widget.serviceLine != null;

  @override
  void initState() {
    super.initState();
    _descCtrl =
        TextEditingController(text: widget.serviceLine?.description ?? '');
    _priceCtrl = TextEditingController(
      text: widget.serviceLine != null
          ? widget.serviceLine!.price.toString()
          : '',
    );
    _groupLabelCtrl =
        TextEditingController(text: widget.serviceLine?.groupLabel ?? '');
    _quantityCtrl = TextEditingController(
      text: (widget.serviceLine?.quantity ?? 1).toString(),
    );
    _selectedHorseId = widget.serviceLine?.horseId;
    _isGroup = widget.serviceLine?.isGroup ?? false;
    _priceCtrl.addListener(() => setState(() {}));
    _quantityCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _groupLabelCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  double get _previewTotal {
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    final quantity = int.tryParse(_quantityCtrl.text.trim()) ?? 0;
    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Service Line' : 'Add Service Line'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Single Animal')),
                  ButtonSegment(value: true, label: Text('Group / Headcount')),
                ],
                selected: {_isGroup},
                onSelectionChanged: (selection) =>
                    setState(() => _isGroup = selection.first),
              ),
              const SizedBox(height: 12),
              if (!_isGroup) ...[
                if (widget.horses.isNotEmpty)
                  DropdownButtonFormField<int?>(
                    value: _selectedHorseId,
                    decoration: const InputDecoration(labelText: 'Animal'),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('General')),
                      ...widget.horses.map((h) =>
                          DropdownMenuItem(value: h.id, child: Text(h.name))),
                    ],
                    onChanged: (v) => setState(() => _selectedHorseId = v),
                  ),
              ] else ...[
                TextFormField(
                  controller: _groupLabelCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Group description',
                    hintText: 'e.g. Back pasture herd, Smith Ranch',
                  ),
                  validator: (v) {
                    if (!_isGroup) return null;
                    return (v?.trim().isEmpty ?? true) ? 'Required' : null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Number of animals'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (!_isGroup) return null;
                    final parsed = int.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 1) {
                      return 'Enter a whole number of 1 or more';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
              ],
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Service'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: InputDecoration(
                  labelText: _isGroup ? 'Price per animal' : 'Price',
                  prefixText: '\$',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              if (_isGroup) ...[
                const SizedBox(height: 8),
                Text(
                  'Total: ${AppUtils.formatCurrency(_previewTotal)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final price = double.parse(_priceCtrl.text.trim());
              if (_isGroup) {
                Navigator.pop(
                  context,
                  ServiceLine(
                    id: widget.serviceLine?.id,
                    visitId: widget.visitId,
                    horseId: null,
                    horseName: 'Group',
                    description: _descCtrl.text.trim(),
                    price: price,
                    quantity: int.parse(_quantityCtrl.text.trim()),
                    isGroup: true,
                    groupLabel: _groupLabelCtrl.text.trim(),
                  ),
                );
              } else {
                Navigator.pop(
                  context,
                  ServiceLine(
                    id: widget.serviceLine?.id,
                    visitId: widget.visitId,
                    horseId: _selectedHorseId,
                    horseName: _selectedHorseId != null
                        ? widget.horses
                            .firstWhere((h) => h.id == _selectedHorseId)
                            .name
                        : 'General',
                    description: _descCtrl.text.trim(),
                    price: price,
                  ),
                );
              }
            }
          },
          child: Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}

// ==================== VISIT CHARGE DIALOG ====================

class VisitChargeDialog extends StatefulWidget {
  final int visitId;
  final VisitCharge? existingCharge;
  final double defaultMileageRate;

  const VisitChargeDialog({
    super.key,
    required this.visitId,
    this.existingCharge,
    this.defaultMileageRate = 0.67,
  });

  @override
  State<VisitChargeDialog> createState() => _VisitChargeDialogState();
}

class _VisitChargeDialogState extends State<VisitChargeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descCtrl;
  late final TextEditingController _quantityCtrl;
  late final TextEditingController _rateCtrl;
  late final TextEditingController _amountCtrl;
  late ChargeType _type;

  bool get isEditing => widget.existingCharge != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingCharge;
    _type = existing?.type ?? ChargeType.mileage;
    _descCtrl = TextEditingController(
      text: existing?.description ?? _defaultDescription(_type),
    );
    _quantityCtrl = TextEditingController(
      text: existing != null && existing.type.isMileageBased
          ? existing.quantity.toString()
          : '',
    );
    _rateCtrl = TextEditingController(
      text: existing != null && existing.type.isMileageBased
          ? existing.rate.toString()
          : widget.defaultMileageRate.toString(),
    );
    _amountCtrl = TextEditingController(
      text: existing != null && !existing.type.isMileageBased
          ? existing.rate.toString()
          : '',
    );
    _quantityCtrl.addListener(() => setState(() {}));
    _rateCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _quantityCtrl.dispose();
    _rateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  String _defaultDescription(ChargeType type) {
    switch (type) {
      case ChargeType.mileage:
        return 'Mileage';
      case ChargeType.transport:
        return 'Transport';
      case ChargeType.tolls:
        return 'Tolls';
      case ChargeType.reimbursement:
        return 'Reimbursement';
      case ChargeType.other:
        return '';
    }
  }

  void _onTypeChanged(ChargeType? type) {
    if (type == null) return;
    setState(() {
      final isUnedited = _descCtrl.text.trim() == _defaultDescription(_type);
      _type = type;
      if (isUnedited) {
        _descCtrl.text = _defaultDescription(type);
      }
    });
  }

  double get _previewTotal {
    if (_type.isMileageBased) {
      final quantity = double.tryParse(_quantityCtrl.text.trim()) ?? 0;
      final rate = double.tryParse(_rateCtrl.text.trim()) ?? 0;
      return quantity * rate;
    }
    return double.tryParse(_amountCtrl.text.trim()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Charge' : 'Add Charge'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<ChargeType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ChargeType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.label),
                        ))
                    .toList(),
                onChanged: _onTypeChanged,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              if (_type.isMileageBased) ...[
                TextFormField(
                  controller: _quantityCtrl,
                  decoration: const InputDecoration(labelText: 'Miles driven'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    final parsed = double.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Enter a number 0 or more';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _rateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Rate per mile',
                    prefixText: '\$',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    final parsed = double.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Enter a number 0 or more';
                    }
                    return null;
                  },
                ),
              ] else
                TextFormField(
                  controller: _amountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    final parsed = double.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Enter a number 0 or more';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 8),
              Text(
                'Total: ${AppUtils.formatCurrency(_previewTotal)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final quantity = _type.isMileageBased
                  ? double.parse(_quantityCtrl.text.trim())
                  : 1.0;
              final rate = _type.isMileageBased
                  ? double.parse(_rateCtrl.text.trim())
                  : double.parse(_amountCtrl.text.trim());
              Navigator.pop(
                context,
                VisitCharge(
                  id: widget.existingCharge?.id,
                  visitId: widget.visitId,
                  type: _type,
                  description: _descCtrl.text.trim(),
                  quantity: quantity,
                  rate: rate,
                ),
              );
            }
          },
          child: Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}

// ==================== SHARED WIDGET ====================

class VisitListTile extends StatelessWidget {
  final Visit visit;
  final VoidCallback onTap;
  final VoidCallback? onConfirm;

  const VisitListTile({
    super.key,
    required this.visit,
    required this.onTap,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: visit.isAutoGenerated
              ? Theme.of(context).colorScheme.surface
              : visit.paid
                  ? Colors.green.shade100
                  : visit.isPast
                      ? Colors.red.shade100
                      : Colors.orange.shade100,
          child: Icon(
            visit.isAutoGenerated
                ? Icons.event_available
                : visit.paid
                    ? Icons.check_circle
                    : visit.isPast
                        ? Icons.warning
                        : Icons.event,
            color: visit.isAutoGenerated
                ? Theme.of(context).colorScheme.primary
                : visit.paid
                    ? Colors.green
                    : visit.isPast
                        ? Colors.red
                        : Colors.orange,
          ),
        ),
        title: Text(visit.clientName),
        subtitle: Text(
          '${AppUtils.formatDateTime(visit.dateTime)}${visit.notes.isNotEmpty ? ' - ${visit.notes}' : ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: onConfirm != null
            ? TextButton(
                onPressed: onConfirm,
                child: const Text('Confirm'),
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
