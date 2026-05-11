import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../services/invoice_service.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class VisitDetailScreen extends StatefulWidget {
  final Visit visit;
  const VisitDetailScreen({super.key, required this.visit});

  @override
  State<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  late Visit _visit;
  List<Horse> _horses = [];
  List<ServiceLine> _serviceLines = [];
  List<VisitPhoto> _photos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _visit = widget.visit;
    _loadData();
  }

  Future<void> _loadData() async {
    final visit = await DatabaseService.getVisit(_visit.id!);
    final horses = await DatabaseService.getHorsesForVisit(_visit.id!);
    final serviceLines = await DatabaseService.getServiceLines(_visit.id!);
    final photos = await DatabaseService.getPhotos(_visit.id!);
    if (mounted) {
      setState(() {
        if (visit != null) _visit = visit;
        _horses = horses;
        _serviceLines = serviceLines;
        _photos = photos;
        _loading = false;
      });
    }
  }

  double get _total => _serviceLines.fold(0.0, (sum, line) => sum + line.price);

  Future<void> _togglePaid(bool value) async {
    await DatabaseService.setVisitPaid(_visit.id!, value);
    setState(() {
      _visit = Visit(
        id: _visit.id,
        clientId: _visit.clientId,
        clientName: _visit.clientName,
        dateTime: _visit.dateTime,
        notes: _visit.notes,
        paid: value,
      );
    });
  }

  Future<void> _addServiceLine() async {
    final result = await showDialog<ServiceLine>(
      context: context,
      builder: (_) => ServiceLineDialog(
        visitId: _visit.id!,
        horses: _horses,
      ),
    );
    if (result != null) {
      await DatabaseService.insertServiceLine(result);
      _loadData();
    }
  }

  Future<void> _editServiceLine(ServiceLine line) async {
    final result = await showDialog<ServiceLine>(
      context: context,
      builder: (_) => ServiceLineDialog(
        visitId: _visit.id!,
        horses: _horses,
        serviceLine: line,
      ),
    );
    if (result != null) {
      await DatabaseService.updateServiceLine(result);
      _loadData();
    }
  }

  Future<void> _deleteServiceLine(ServiceLine line) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Service Line',
      message: 'Remove "${line.description}"?',
    );
    if (confirmed == true) {
      await DatabaseService.deleteServiceLine(line.id!);
      _loadData();
    }
  }

  Future<void> _addPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final captionCtrl = TextEditingController();
    final includeOnInvoice = ValueNotifier<bool>(true);
    int? horseId;

    if (mounted) {
      final saved = await showDialog<bool>(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            title: const Text('Photo Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(File(image.path), height: 150, fit: BoxFit.cover),
                  const SizedBox(height: 12),
                  if (_horses.isNotEmpty)
                    DropdownButtonFormField<int?>(
                      value: horseId,
                      decoration: const InputDecoration(labelText: 'Horse'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('None')),
                        ..._horses.map((h) => DropdownMenuItem(
                              value: h.id,
                              child: Text(h.name),
                            )),
                      ],
                      onChanged: (v) => setDialogState(() => horseId = v),
                    ),
                  TextField(
                    controller: captionCtrl,
                    decoration: const InputDecoration(labelText: 'Caption'),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: includeOnInvoice,
                    builder: (context, value, child) => SwitchListTile(
                      title: const Text('Include on invoice'),
                      value: value,
                      onChanged: (v) => includeOnInvoice.value = v,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );

      if (saved == true) {
        await DatabaseService.insertPhoto(VisitPhoto(
          visitId: _visit.id!,
          horseId: horseId,
          path: image.path,
          caption: captionCtrl.text.trim(),
          includeOnInvoice: includeOnInvoice.value,
        ));
        _loadData();
      }
      captionCtrl.dispose();
    }
  }

  Future<void> _deletePhoto(VisitPhoto photo) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Photo',
      message: 'Remove this photo?',
    );
    if (confirmed == true) {
      await DatabaseService.deletePhoto(photo.id!);
      _loadData();
    }
  }

  Future<void> _generateInvoice() async {
  final client = await DatabaseService.getClient(_visit.clientId);
  if (client == null) return;

  try {
    final file = await InvoiceService.generateInvoice(
      visit: _visit,
      client: client,
      serviceLines: _serviceLines,
      photos: _photos,
    );

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Invoice (PDF)'),
              subtitle: const Text(
                  'Send via any app - Gmail, WhatsApp, etc.'),
              onTap: () {
                Navigator.pop(context);
                InvoiceService.shareInvoice(
                  file,
                  subject: 'Invoice for ${client.fullName}',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Print Invoice'),
              onTap: () {
                Navigator.pop(context);
                InvoiceService.printInvoice(file);
              },
            ),
          ],
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error generating invoice: $e')),
    );
  }
}

  Future<void> _deleteVisit() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Visit',
      message: 'Are you sure you want to delete this visit?',
    );
    if (confirmed == true) {
      await DatabaseService.deleteVisit(_visit.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  void _showPhotoFullScreen(VisitPhoto photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(photo.caption.isNotEmpty ? photo.caption : 'Photo'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(photo.path)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Visit')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_visit.clientName),
        actions: [
          if (_serviceLines.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.receipt_long),
              tooltip: 'Generate Invoice',
              onPressed: _generateInvoice,
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _deleteVisit();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Visit', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
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
                        Expanded(
                          child: Text(
                            AppUtils.formatDateTimeForInvoice(_visit.dateTime),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        VisitStatusChip(visit: _visit),
                      ],
                    ),
                    if (_visit.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(_visit.notes),
                    ],
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Paid'),
                      value: _visit.paid,
                      onChanged: _togglePaid,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionHeader(title: 'Horses (${_horses.length})'),
            if (_horses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No horses selected for this visit'),
              )
            else
              ..._horses.map((h) => ListTile(
                    leading: HorseAvatar(horse: h, radius: 20),
                    title: Text(h.name),
                  )),
            const SizedBox(height: 16),
            SectionHeader(
              title: 'Billing',
              onAdd: _addServiceLine,
              addLabel: 'Add Line',
            ),
            if (_serviceLines.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No service lines yet'),
              )
            else ...[
              ..._serviceLines.map((line) => ServiceLineCard(
                    line: line,
                    onEdit: () => _editServiceLine(line),
                    onDelete: () => _deleteServiceLine(line),
                  )),
              const Divider(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    Text(
                      AppUtils.formatCurrency(_total),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _visit.paid ? Colors.green : Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
              if (!_visit.paid)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: _generateInvoice,
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Generate Invoice'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 16),
            SectionHeader(
              title: 'Photos (${_photos.length})',
              onAdd: _addPhoto,
              addLabel: 'Add Photo',
            ),
            if (_photos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No photos yet'),
              )
            else
              PhotoGrid(
                photos: _photos,
                onTap: (photo) => _showPhotoFullScreen(photo),
                onLongPress: (photo) => _deletePhoto(photo),
              ),
          ],
        ),
      ),
    );
  }
}

