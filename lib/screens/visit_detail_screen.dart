import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
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
  List<InvoiceRecord> _invoices = [];
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
    final invoices = await DatabaseService.getInvoicesForVisit(_visit.id!);
    if (mounted) {
      setState(() {
        if (visit != null) _visit = visit;
        _horses = horses;
        _serviceLines = serviceLines;
        _photos = photos;
        _invoices = invoices;
        _loading = false;
      });
    }
  }

  double get _total => _serviceLines.fold(0.0, (sum, line) => sum + line.price);

  Future<void> _togglePaid(bool value) async {
    final wasPaid = _visit.paid;
    await DatabaseService.setVisitPaid(_visit.id!, value);
    await DatabaseService.setInvoicesPaidForVisit(_visit.id!, value);
    setState(() {
      _visit = Visit(
        id: _visit.id,
        clientId: _visit.clientId,
        clientName: _visit.clientName,
        dateTime: _visit.dateTime,
        notes: _visit.notes,
        paid: value,
        recurrenceWeeks: _visit.recurrenceWeeks,
        nextRecurringVisitId: _visit.nextRecurringVisitId,
        createdAt: _visit.createdAt,
      );
    });
    if (!mounted) return;
    if (!wasPaid &&
        value &&
        _visit.recurrenceWeeks != null &&
        _visit.nextRecurringVisitId == null) {
      final scheduleNext = await ConfirmationDialog.show(
        context,
        title: 'Recurring Visit',
        message: 'Schedule next recurring visit?',
      );
      if (scheduleNext == true) {
        await DatabaseService.createNextRecurringVisit(_visit);
      }
    }
    _loadData();
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
                      decoration: const InputDecoration(labelText: 'Animal'),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('None')),
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
    if (_invoices.isNotEmpty) {
      await _viewInvoice(_invoices.first);
      return;
    }

    final client = await DatabaseService.getClient(_visit.clientId);
    if (client == null) return;

    try {
      final issuedAt = DateTime.now();
      final invoiceNumber =
          await DatabaseService.getNextInvoiceNumber(issuedAt);
      final file = await InvoiceService.generateInvoice(
        visit: _visit,
        client: client,
        serviceLines: _serviceLines,
        photos: _photos,
        invoiceNumber: invoiceNumber,
      );

      final invoice = InvoiceRecord(
        visitId: _visit.id!,
        invoiceNumber: invoiceNumber,
        issuedAt: issuedAt,
        paidAt: _visit.paid ? issuedAt : null,
        total: _total,
        filePath: file.path,
        fileName: file.path.split('/').last,
      );
      final invoiceId = await DatabaseService.insertInvoice(invoice);

      if (!mounted) return;
      setState(
        () => _invoices = [
          InvoiceRecord(
            id: invoiceId,
            visitId: invoice.visitId,
            invoiceNumber: invoice.invoiceNumber,
            issuedAt: invoice.issuedAt,
            paidAt: invoice.paidAt,
            total: invoice.total,
            filePath: invoice.filePath,
            fileName: invoice.fileName,
            createdAt: invoice.createdAt,
            updatedAt: invoice.updatedAt,
          ),
        ],
      );

      showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Invoice (PDF)'),
                subtitle:
                    const Text('Send via any app - Gmail, WhatsApp, etc.'),
                onTap: () {
                  Navigator.pop(context);

                  final safeClientName = client.fullName
                      .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
                      .replaceAll(RegExp(r'_+'), '_')
                      .replaceAll(RegExp(r'^_|_$'), '');

                  final date =
                      _visit.dateTime.toIso8601String().split('T').first;
                  final docType = _visit.paid ? 'Receipt' : 'Invoice';
                  final fileName = '${safeClientName}_${date}_$docType.pdf';

                  InvoiceService.shareInvoice(
                    file,
                    subject: '$docType for ${client.fullName}',
                    fileName: fileName,
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

  Future<File?> _ensureInvoiceFile(InvoiceRecord invoice) async {
    if (invoice.filePath.isNotEmpty) {
      final existing = File(invoice.filePath);
      if (await existing.exists()) return existing;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invoice PDF not found: ${invoice.fileName.isEmpty ? invoice.invoiceNumber : invoice.fileName}',
          ),
        ),
      );
    }
    return null;
  }

  Future<void> _viewInvoice(InvoiceRecord invoice) async {
    final file = await _ensureInvoiceFile(invoice);
    if (!mounted || file == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(invoice.invoiceNumber)),
          body: PdfPreview(
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            build: (_) => file.readAsBytes(),
          ),
        ),
      ),
    );
  }

  Future<void> _shareInvoiceRecord(InvoiceRecord invoice) async {
    final file = await _ensureInvoiceFile(invoice);
    if (file == null) return;

    await InvoiceService.shareInvoice(
      file,
      subject: 'Invoice ${invoice.invoiceNumber}',
      fileName: invoice.fileName,
    );
  }

  Future<void> _printInvoiceRecord(InvoiceRecord invoice) async {
    final file = await _ensureInvoiceFile(invoice);
    if (file == null) return;

    await InvoiceService.printInvoice(file);
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
              tooltip: _invoices.isEmpty ? 'Create Invoice' : 'View Invoice',
              onPressed: _invoices.isEmpty
                  ? _generateInvoice
                  : () => _viewInvoice(_invoices.first),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewVisitScreen(visit: _visit),
                  ),
                ).then((_) => _loadData());
              }
              if (value == 'delete') _deleteVisit();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit Visit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child:
                    Text('Delete Visit', style: TextStyle(color: Colors.red)),
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
            SectionHeader(title: 'Animals (${_horses.length})'),
            if (_horses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No animals selected for this visit'),
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
              addLabel: 'Add Service Line',
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
                            color: _visit.paid
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
              if (!_visit.paid && _invoices.isEmpty)
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
              title: 'Invoice History',
              onAdd: _serviceLines.isNotEmpty && _invoices.isEmpty
                  ? _generateInvoice
                  : null,
              addLabel: 'Create Invoice',
            ),
            if (_invoices.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: _serviceLines.isEmpty
                    ? const Text('Add service lines before creating an invoice')
                    : ElevatedButton.icon(
                        onPressed: _generateInvoice,
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('Create Invoice'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
              )
            else
              ..._invoices.map(
                (invoice) => Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: invoice.paidAt != null
                          ? Colors.green.shade100
                          : Theme.of(context).colorScheme.secondaryContainer,
                      child: Icon(
                        invoice.paidAt != null
                            ? Icons.check_circle
                            : Icons.receipt_long,
                        color: invoice.paidAt != null
                            ? Colors.green
                            : Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                      ),
                    ),
                    title: Text(invoice.invoiceNumber),
                    subtitle: Text(
                      '${AppUtils.formatDate(invoice.issuedAt)} · ${invoice.paidAt != null ? 'Paid' : 'Unpaid'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppUtils.formatCurrency(invoice.total)),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') _viewInvoice(invoice);
                            if (value == 'share') _shareInvoiceRecord(invoice);
                            if (value == 'print') _printInvoiceRecord(invoice);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'view',
                              child: Text('View'),
                            ),
                            PopupMenuItem(
                              value: 'share',
                              child: Text('Share'),
                            ),
                            PopupMenuItem(
                              value: 'print',
                              child: Text('Print'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _viewInvoice(invoice),
                  ),
                ),
              ),
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
