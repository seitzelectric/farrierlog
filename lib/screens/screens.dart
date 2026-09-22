export 'visit_detail_screen.dart';
export 'client_form_dialog.dart';
export 'dashboard_screen.dart';
export 'dashboard_list_screen.dart';
export 'client_list_screen.dart';
export 'home_screen.dart';
export 'calendar_screen.dart';
export 'new_visit_screen.dart';
export 'horse_detail_screen.dart';
export 'invoice_history_screen.dart';
export 'animal_list_screen.dart';
export 'photo_comparison_screen.dart';
export 'today_route_screen.dart';
export 'onboarding_screen.dart';
export 'help_screen.dart';
import 'new_visit_screen.dart';
import 'horse_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.deleteClientTitle,
      message: l10n.clientDetailDeleteMessage(_client.fullName),
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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.deleteAnimalTitle,
      message: l10n.deleteAnimalConfirmMessage(horse.name),
    );
    if (confirmed == true) {
      await DatabaseService.deleteHorse(horse.id!);
      _loadData();
    }
  }

  Future<bool> _confirmDeleteHorse(Horse horse) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.deleteAnimalTitle,
      message: l10n.deleteAnimalConfirmMessage(horse.name),
    );
    if (confirmed == true) {
      await DatabaseService.deleteHorse(horse.id!);
      await _loadData();
    }
    return false;
  }

  Future<bool> _confirmDeleteVisit(Visit visit) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.deleteVisitTitle,
      message: l10n.deleteVisitConfirmMessageWithDate(AppUtils.formatDateTime(visit.dateTime)),
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
    final l10n = AppLocalizations.of(context)!;
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
              PopupMenuItem(value: 'edit', child: Text(l10n.editClientTitle)),
              PopupMenuItem(
                value: 'delete',
                child:
                    Text(l10n.deleteClientTitle, style: const TextStyle(color: Colors.red)),
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
                  ElevatedButton.icon(
                    onPressed: _addVisit,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(l10n.scheduleVisitButton),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                              subtitle: Text(l10n.tapToCallLongPressText),
                              onTap: () => _openUri('tel:${_client.phone}'),
                              onLongPress: () =>
                                  _openUri('sms:${_client.phone}'),
                            ),
                          if (_client.email.isNotEmpty)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.email),
                              title: Text(_client.email),
                              subtitle: Text(l10n.tapToEmail),
                              onTap: () => _openUri('mailto:${_client.email}'),
                            ),
                          if (_client.address.isNotEmpty)
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.map),
                              title: Text(_client.address),
                              subtitle: Text(l10n.openInMaps),
                              onTap: () => AppUtils.openGoogleMapsSearch(
                                _client.address,
                              ),
                            ),
                          if (_client.notes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(l10n.notesLabel(_client.notes)),
                            ),
                          if (_client.internalNotes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.amber.shade200),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lock_outline,
                                            size: 16,
                                            color: Colors.amber.shade700),
                                        const SizedBox(width: 6),
                                        Text(
                                          l10n.privateStaffNotesTitle,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(_client.internalNotes),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: l10n.animalsCountTitle(_horses.length),
                    onAdd: _addHorseDialog,
                    addLabel: l10n.addAnimalLabel,
                  ),
                  if (_horses.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noAnimalsAddedYet),
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
                                  PopupMenuItem(
                                      value: 'edit', child: Text(l10n.edit)),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text(l10n.delete,
                                        style: const TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final horseWithInfo = HorseWithClientInfo(
                                  horse: horse,
                                  client: _client,
                                );
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HorseDetailScreen(animal: horseWithInfo),
                                  ),
                                );
                                _loadData();
                              },
                            ),
                          ),
                        )),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: l10n.visitsCountHeader(_visits.length),
                    onAdd: _addVisit,
                    addLabel: l10n.newVisitLabel,
                  ),
                  if (_visits.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noVisitsYet),
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
  late final TextEditingController _internalNotesCtrl;

  bool get isEditing => widget.horse != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.horse?.name ?? '');
    _breedCtrl = TextEditingController(text: widget.horse?.breed ?? '');
    _colorCtrl = TextEditingController(text: widget.horse?.color ?? '');
    _notesCtrl = TextEditingController(text: widget.horse?.notes ?? '');
    _internalNotesCtrl =
        TextEditingController(text: widget.horse?.internalNotes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _colorCtrl.dispose();
    _notesCtrl.dispose();
    _internalNotesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(isEditing ? l10n.editAnimalTitle : l10n.newAnimalTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l10n.nameLabel),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? l10n.requiredField : null,
              ),
              TextFormField(
                controller: _breedCtrl,
                decoration: InputDecoration(labelText: l10n.speciesLabel),
              ),
              TextFormField(
                controller: _colorCtrl,
                decoration: InputDecoration(labelText: l10n.descriptionLabel),
              ),
              TextFormField(
                controller: _notesCtrl,
                decoration: InputDecoration(
                  labelText: l10n.animalNotesLabel,
                  hintText: l10n.animalNotesHint,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: TextFormField(
                  controller: _internalNotesCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.internalNotesLabel,
                    hintText: l10n.internalNotesHintAnimal,
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.amber),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                  ),
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
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
                  internalNotes: _internalNotesCtrl.text.trim(),
                ),
              );
            }
          },
          child: Text(isEditing ? l10n.update : l10n.save),
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
  List<ServiceTemplate> _templates = [];

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
    DatabaseService.getServiceTemplates().then((t) {
      if (mounted) setState(() => _templates = t);
    });
  }

  void _applyTemplate(ServiceTemplate t) {
    setState(() {
      _descCtrl.text = t.description;
      _priceCtrl.text = t.price.toStringAsFixed(2);
      _quantityCtrl.text = t.quantity.toString();
      if (t.isGroup) _isGroup = true;
    });
  }

  Future<void> _saveAsTemplate() async {
    final l10n = AppLocalizations.of(context)!;
    final description = _descCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterDescriptionFirstSnackbar)),
      );
      return;
    }
    final template = ServiceTemplate(
      description: description,
      price: price,
      quantity: int.tryParse(_quantityCtrl.text.trim()) ?? 1,
      isGroup: _isGroup,
    );
    await DatabaseService.insertServiceTemplate(template);
    final templates = await DatabaseService.getServiceTemplates();
    if (mounted) {
      setState(() => _templates = templates);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.templateSavedSnackbar(description))),
      );
    }
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
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(isEditing ? l10n.editServiceLineTitle : l10n.addServiceLineTitle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_templates.isNotEmpty) ...[
                Text(l10n.savedTemplatesLabel,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _templates
                      .map((t) => ActionChip(
                            label: Text(
                              '${t.description} ${AppUtils.formatCurrency(t.price)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () => _applyTemplate(t),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: false, label: Text(l10n.singleAnimalOption)),
                  ButtonSegment(value: true, label: Text(l10n.groupHeadcountOption)),
                ],
                selected: {_isGroup},
                onSelectionChanged: (selection) =>
                    setState(() => _isGroup = selection.first),
              ),
              const SizedBox(height: 12),
              if (!_isGroup) ...[
                if (widget.horses.isNotEmpty)
                  DropdownButtonFormField<int?>(
                    initialValue: _selectedHorseId,
                    decoration: InputDecoration(labelText: l10n.animalDropdownLabel),
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text(l10n.generalLabel)),
                      ...widget.horses.map((h) =>
                          DropdownMenuItem(value: h.id, child: Text(h.name))),
                    ],
                    onChanged: (v) => setState(() => _selectedHorseId = v),
                  ),
              ] else ...[
                TextFormField(
                  controller: _groupLabelCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.groupDescriptionLabel,
                    hintText: l10n.groupDescriptionHint,
                  ),
                  validator: (v) {
                    if (!_isGroup) return null;
                    return (v?.trim().isEmpty ?? true) ? l10n.requiredField : null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityCtrl,
                  decoration:
                      InputDecoration(labelText: l10n.numberOfAnimalsLabel),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (!_isGroup) return null;
                    final parsed = int.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 1) {
                      return l10n.enterWholeNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
              ],
              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(labelText: l10n.serviceLabel),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? l10n.requiredField : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: InputDecoration(
                  labelText: _isGroup ? l10n.pricePerAnimalLabel : l10n.priceLabel,
                  prefixText: '\$',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l10n.requiredField;
                  if (double.tryParse(v) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              if (_isGroup) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.totalLabel(AppUtils.formatCurrency(_previewTotal)),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                  label: Text(l10n.saveAsTemplateButton),
                  onPressed: _saveAsTemplate,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
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
          child: Text(isEditing ? l10n.update : l10n.save),
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

  bool _descInitialized = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingCharge;
    _type = existing?.type ?? ChargeType.mileage;
    _descCtrl = TextEditingController(text: existing?.description ?? '');
    _descInitialized = existing != null;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_descInitialized) {
      _descInitialized = true;
      _descCtrl.text = _defaultDescription(_type, AppLocalizations.of(context)!);
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _quantityCtrl.dispose();
    _rateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  String _defaultDescription(ChargeType type, AppLocalizations l10n) {
    switch (type) {
      case ChargeType.mileage:
        return l10n.chargeTypeMileage;
      case ChargeType.transport:
        return l10n.chargeTypeTransport;
      case ChargeType.tolls:
        return l10n.chargeTypeTolls;
      case ChargeType.reimbursement:
        return l10n.chargeTypeReimbursement;
      case ChargeType.other:
        return '';
    }
  }

  void _onTypeChanged(ChargeType? type) {
    if (type == null) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      final isUnedited = _descCtrl.text.trim() == _defaultDescription(_type, l10n);
      _type = type;
      if (isUnedited) {
        _descCtrl.text = _defaultDescription(type, l10n);
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
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(isEditing ? l10n.editChargeTitle : l10n.addChargeTitle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<ChargeType>(
                initialValue: _type,
                decoration: InputDecoration(labelText: l10n.typeLabel),
                items: ChargeType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.label(l10n)),
                        ))
                    .toList(),
                onChanged: _onTypeChanged,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(labelText: l10n.descriptionLabel),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? l10n.requiredField : null,
              ),
              const SizedBox(height: 8),
              if (_type.isMileageBased) ...[
                TextFormField(
                  controller: _quantityCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.distanceLabelWithUnit(AppUtils.distanceUnit),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    final parsed = double.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return l10n.enterNumberZeroOrMore;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _rateCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.ratePerUnitLabel(AppUtils.distanceUnit),
                    prefixText: '\$',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    final parsed = double.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return l10n.enterNumberZeroOrMore;
                    }
                    return null;
                  },
                ),
              ] else
                TextFormField(
                  controller: _amountCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.amountLabel,
                    prefixText: '\$',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    final parsed = double.tryParse(v?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return l10n.enterNumberZeroOrMore;
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 8),
              Text(
                l10n.totalLabel(AppUtils.formatCurrency(_previewTotal)),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
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
          child: Text(isEditing ? l10n.update : l10n.save),
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
                child: Text(AppLocalizations.of(context)!.confirm),
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
