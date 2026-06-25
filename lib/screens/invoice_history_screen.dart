import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import '../models/models.dart';
import '../services/database_service.dart';
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
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'Invoice History Export',
          text: 'Invoice history CSV export',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _viewInvoice(Map<String, dynamic> row) async {
    final filePath = row['file_path'] as String? ?? '';
    final invoiceNumber = row['invoice_number'] as String? ?? 'Invoice';
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No PDF file found for this invoice')),
      );
      return;
    }
    final file = File(filePath);
    if (!await file.exists()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF file not found: $filePath')),
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
    final filePath = row['file_path'] as String? ?? '';
    final fileName = row['file_name'] as String? ?? 'invoice.pdf';
    if (filePath.isEmpty) return;
    final file = File(filePath);
    if (!await file.exists()) return;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Invoice ${row['invoice_number'] ?? ''}',
        text: fileName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice History'),
        actions: [
          if (_hasFilters)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Clear filters',
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
            tooltip: 'Export CSV',
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
                              ? 'From: ${AppUtils.formatDate(_fromDate!)}'
                              : 'From date',
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
                              ? 'To: ${AppUtils.formatDate(_toDate!)}'
                              : 'To date',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  initialValue: _selectedClientId,
                  decoration: const InputDecoration(
                    labelText: 'Client',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                        value: null, child: Text('All clients')),
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
                  '${_results.length} invoice${_results.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                if (_results.isNotEmpty)
                  Text(
                    'Total: ${AppUtils.formatCurrency(_results.fold(0.0, (sum, r) => sum + ((r['total'] as num?)?.toDouble() ?? 0.0)))}',
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
                            const Text('No invoices found'),
                            if (_hasFilters) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _clearFilters,
                                child: const Text('Clear filters'),
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
                                        isPaid ? 'Paid' : 'Unpaid',
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
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                          value: 'view', child: Text('View')),
                                      PopupMenuItem(
                                          value: 'share', child: Text('Share')),
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
