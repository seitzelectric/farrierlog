import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../services/invoice_service.dart';
import '../utils/utils.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  List<Map<String, dynamic>> _results = [];
  List<Client> _clients = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  int? _selectedClientId;
  bool _loading = true;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final clients = await DatabaseService.getClients();
    final results = await DatabaseService.searchInvoices(
      fromDate: _fromDate,
      toDate: _toDate,
      clientId: _selectedClientId,
    );
    if (mounted) {
      setState(() {
        _clients = clients;
        _results = results;
        _loading = false;
      });
    }
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _fromDate = picked);
      _loadData();
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _toDate = picked);
      _loadData();
    }
  }

  void _clearFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedClientId = null;
    });
    _loadData();
  }

  bool get _hasFilters =>
      _fromDate != null || _toDate != null || _selectedClientId != null;

  Future<void> _exportCsv() async {
    if (_results.isEmpty) return;
    setState(() => _exporting = true);
    try {
      final buffer = StringBuffer();
      buffer.writeln('Invoice #,Date,Client,Total,Status,File');
      for (final row in _results) {
        final invoiceNumber = row['invoice_number'] as String? ?? '';
        final issuedAtStr = row['issued_at'] as String? ?? '';
        final issuedAt = DateTime.tryParse(issuedAtStr) ?? DateTime.now();
        final clientFirst = row['client_first_name'] as String? ?? '';
        final clientLast = row['client_last_name'] as String? ?? '';
        final clientName = '$clientFirst $clientLast'.trim();
        final total = (row['total'] as num?)?.toDouble() ?? 0.0;
        final paidAt = row['paid_at'] as String?;
        final status = paidAt != null && paidAt.isNotEmpty ? 'Paid' : 'Unpaid';
        final fileName = row['file_name'] as String? ?? '';
        buffer.writeln(
          '"$invoiceNumber","${AppUtils.formatDate(issuedAt)}","$clientName",'
          '"${AppUtils.formatCurrency(total)}","$status","$fileName"',
        );
      }
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/invoice_history.csv');
      await file.writeAsString(buffer.toString());
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: l10n.exportCsvShareSubject,
          text: l10n.exportCsvShareText,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.exportFailedSnackbar('$e'))),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _viewInvoice(Map<String, dynamic> row) async {
    final l10n = AppLocalizations.of(context)!;
    final filePath = row['file_path'] as String? ?? '';
    final invoiceNumber = row['invoice_number'] as String? ?? 'Invoice';
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noPdfFoundSnackbar)),
      );
      return;
    }
    final file = File(filePath);
    if (!await file.exists()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pdfNotFoundSnackbar(filePath))),
      );
      return;
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(invoiceNumber)),
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

  Future<void> _shareInvoice(Map<String, dynamic> row) async {
    final l10n = AppLocalizations.of(context)!;
    final filePath = row['file_path'] as String? ?? '';
    final fileName = row['file_name'] as String? ?? 'invoice.pdf';
    final invoiceNumber = row['invoice_number'] as String? ?? '';
    final visitId = row['visit_id'] as int?;

    if (filePath.isEmpty || visitId == null) return;
    final file = File(filePath);
    if (!await file.exists()) return;

    final photos = await DatabaseService.getPhotos(visitId);
    final hasInvoicePhotos = photos.any((p) => p.includeOnInvoice);

    if (!hasInvoicePhotos || !mounted) {
      await InvoiceService.shareInvoice(
        file,
        subject: l10n.invoiceNumberSubject(invoiceNumber),
        fileName: fileName,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(l10n.shareInvoiceOnlyTitle),
              subtitle: Text(l10n.shareInvoiceOnlySubtitle),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  final visit = await DatabaseService.getVisit(visitId);
                  if (visit == null || !mounted) return;
                  final client =
                      await DatabaseService.getClient(visit.clientId);
                  if (client == null || !mounted) return;
                  final serviceLines =
                      await DatabaseService.getServiceLines(visitId);
                  final charges =
                      await DatabaseService.getVisitCharges(visitId);
                  final invoiceOnlyFile =
                      await InvoiceService.generateInvoice(
                    visit: visit,
                    client: client,
                    serviceLines: serviceLines,
                    charges: charges,
                    photos: photos,
                    invoiceNumber: invoiceNumber,
                    includePhotos: false,
                  );
                  await InvoiceService.shareInvoice(
                    invoiceOnlyFile,
                    subject: l10n.invoiceNumberSubject(invoiceNumber),
                    fileName: fileName,
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.errorSharingInvoiceSnackbar('$e'))),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.shareInvoicePhotosTitle),
              subtitle: Text(l10n.shareInvoicePhotosSubtitle),
              onTap: () {
                Navigator.pop(ctx);
                InvoiceService.shareInvoice(
                  file,
                  subject: l10n.invoiceNumberSubject(invoiceNumber),
                  fileName: fileName,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.invoiceHistoryTitle),
        actions: [
          if (_hasFilters)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: l10n.clearFiltersTooltip,
              onPressed: _clearFilters,
            ),
          IconButton(
            icon: _exporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share),
            tooltip: l10n.exportCsvTooltip,
            onPressed: _exporting ? null : _exportCsv,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickFromDate,
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(
                          _fromDate != null
                              ? l10n.fromDateLabel(AppUtils.formatDate(_fromDate!))
                              : l10n.fromDatePlaceholder,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickToDate,
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(
                          _toDate != null
                              ? l10n.toDateLabel(AppUtils.formatDate(_toDate!))
                              : l10n.toDatePlaceholder,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  initialValue: _selectedClientId,
                  decoration: InputDecoration(
                    labelText: l10n.clientDropdownLabel,
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                        value: null, child: Text(l10n.allClientsOption)),
                    ..._clients.map((c) =>
                        DropdownMenuItem(value: c.id, child: Text(c.fullName))),
                  ],
                  onChanged: (id) {
                    setState(() => _selectedClientId = id);
                    _loadData();
                  },
                ),
              ],
            ),
          ),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  l10n.invoiceCount(_results.length),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                if (_results.isNotEmpty)
                  Text(
                    l10n.totalLabel(AppUtils.formatCurrency(_results.fold(0.0, (sum, r) => sum + ((r['total'] as num?)?.toDouble() ?? 0.0)))),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.outline),
                            const SizedBox(height: 16),
                            Text(l10n.noInvoicesFound),
                            if (_hasFilters) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _clearFilters,
                                child: Text(l10n.clearFiltersTooltip),
                              ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: _results.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, indent: 16),
                          itemBuilder: (context, index) {
                            final row = _results[index];
                            final invoiceNumber =
                                row['invoice_number'] as String? ?? '';
                            final issuedAtStr =
                                row['issued_at'] as String? ?? '';
                            final issuedAt = DateTime.tryParse(issuedAtStr) ??
                                DateTime.now();
                            final clientFirst =
                                row['client_first_name'] as String? ?? '';
                            final clientLast =
                                row['client_last_name'] as String? ?? '';
                            final clientName =
                                '$clientFirst $clientLast'.trim();
                            final total = (row['total'] as num?)?.toDouble() ??
                                0.0;
                            final paidAt = row['paid_at'] as String?;
                            final isPaid =
                                paidAt != null && paidAt.isNotEmpty;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isPaid
                                    ? Colors.green.shade100
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                child: Icon(
                                  isPaid
                                      ? Icons.check_circle
                                      : Icons.receipt_long,
                                  size: 20,
                                  color: isPaid
                                      ? Colors.green
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                ),
                              ),
                              title: Text(invoiceNumber.isNotEmpty
                                  ? invoiceNumber
                                  : clientName),
                              subtitle: Text(
                                '${AppUtils.formatDate(issuedAt)} · $clientName',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppUtils.formatCurrency(total),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Text(
                                        isPaid ? l10n.paidLabel : l10n.unpaidLabel,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isPaid
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'view') _viewInvoice(row);
                                      if (value == 'share') _shareInvoice(row);
                                    },
                                    itemBuilder: (_) => [
                                      PopupMenuItem(
                                          value: 'view', child: Text(l10n.view)),
                                      PopupMenuItem(
                                          value: 'share', child: Text(l10n.share)),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () => _viewInvoice(row),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
