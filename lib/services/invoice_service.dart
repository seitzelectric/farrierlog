import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import '../models/models.dart';
import '../utils/utils.dart';
import 'database_service.dart';

class CompanyInfo {
  String name;
  String address;
  String phone;
  String email;
  String? logoPath;

  CompanyInfo({
    this.name = '',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.logoPath,
  });

  Map<String, String> toMap() => {
        'company_name': name,
        'company_address': address,
        'company_phone': phone,
        'company_email': email,
        'company_logo': logoPath ?? '',
      };

  factory CompanyInfo.fromMap(Map<String, dynamic> map) => CompanyInfo(
        name: map['company_name'] as String? ?? '',
        address: map['company_address'] as String? ?? '',
        phone: map['company_phone'] as String? ?? '',
        email: map['company_email'] as String? ?? '',
        logoPath: map['company_logo'] as String?,
      );

  bool get isComplete => name.isNotEmpty;
}

class InvoiceService {
  static CompanyInfo _companyInfo = CompanyInfo();

  static CompanyInfo get companyInfo => _companyInfo;

  static Future<void> loadCompanyInfo() async {
    _companyInfo = CompanyInfo(
      name: await DatabaseService.getSetting('company_name'),
      address: await DatabaseService.getSetting('company_address'),
      phone: await DatabaseService.getSetting('company_phone'),
      email: await DatabaseService.getSetting('company_email'),
      logoPath: await DatabaseService.getSetting('company_logo'),
    );

    if (_companyInfo.logoPath != null && _companyInfo.logoPath!.isEmpty) {
      _companyInfo.logoPath = null;
    }
  }

  static void setCompanyInfo(CompanyInfo info) {
    _companyInfo = info;
  }

  static Future<File> generateInvoice({
    required Visit visit,
    required Client client,
    required List<ServiceLine> serviceLines,
    required List<VisitPhoto> photos,
    String? invoiceNumber,
  }) async {
    await loadCompanyInfo();

    final pdf = pw.Document();
    final total = serviceLines.fold(0.0, (sum, line) => sum + line.price);
    final invoicePhotos = photos.where((p) => p.includeOnInvoice).toList();
    final company = _companyInfo;

    // Load logo if available
    pw.MemoryImage? logoImage;
    if (company.logoPath != null && company.logoPath!.isNotEmpty) {
      final logoFile = File(company.logoPath!);
      if (logoFile.existsSync()) {
        logoImage = pw.MemoryImage(logoFile.readAsBytesSync());
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(company, logoImage),
        build: (context) => [
          pw.SizedBox(height: 16),

          // Client and Visit Info
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bill To:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(client.fullName),
                    if (client.address.isNotEmpty) pw.Text(client.address),
                    if (client.phone.isNotEmpty) pw.Text(client.phone),
                    if (client.email.isNotEmpty) pw.Text(client.email),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Visit Details:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(AppUtils.formatDateTimeForInvoice(visit.dateTime)),
                    if (visit.notes.isNotEmpty)
                      pw.Text('Notes: ${visit.notes}'),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 24),

          // Invoice Title
          pw.Center(
            child: pw.Text('INVOICE',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text('Date: ${AppUtils.formatDate(DateTime.now())}'),
          pw.Text(invoiceNumber != null
              ? 'Invoice #$invoiceNumber'
              : 'Visit #${visit.id}'),
          pw.SizedBox(height: 16),

          // Service Lines Table
          pw.Text('Services',
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _tableCell('Name', bold: true),
                  _tableCell('Description', bold: true),
                  _tableCell('Service', bold: true),
                  _tableCell('Price', bold: true, align: pw.TextAlign.right),
                ],
              ),
              ...serviceLines.map((line) => pw.TableRow(
                    children: [
                      _tableCell(line.horseName),
                      _tableCell(
                        '${line.horseBreed.isNotEmpty ? line.horseBreed : ''}'
                        '${line.horseBreed.isNotEmpty && line.horseColor.isNotEmpty ? ' / ' : ''}'
                        '${line.horseColor.isNotEmpty ? line.horseColor : ''}',
                      ),
                      _tableCell(line.description),
                      _tableCell(
                        AppUtils.formatCurrency(line.price),
                        align: pw.TextAlign.right,
                      ),
                    ],
                  )),
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _tableCell('Total', bold: true),
                  _tableCell(''),
                  _tableCell(''),
                  _tableCell(AppUtils.formatCurrency(total),
                      bold: true, align: pw.TextAlign.right),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // Payment Status
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
              color: visit.paid ? PdfColors.green100 : PdfColors.red100,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Status:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(visit.paid ? 'PAID' : 'UNPAID',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: visit.paid ? PdfColors.green : PdfColors.red,
                    )),
              ],
            ),
          ),

          // Photos
          if (invoicePhotos.isNotEmpty) ...[
            pw.SizedBox(height: 24),
            pw.Text('Photos',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            ...invoicePhotos.map((photo) {
              final file = File(photo.path);
              if (file.existsSync()) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Image(
                      pw.MemoryImage(file.readAsBytesSync()),
                      height: 120,
                    ),
                    if (photo.caption.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4, bottom: 8),
                        child: pw.Text(photo.caption,
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                  ],
                );
              }
              return pw.SizedBox();
            }),
          ],

          // Footer
          pw.SizedBox(height: 32),
          pw.Divider(),
          pw.Center(
            child: pw.Text('Thank you for your business!',
                style:
                    pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
          ),
        ],
      ),
    );

    final output = invoiceNumber == null
        ? await getTemporaryDirectory()
        : await _invoiceDirectory(visit.dateTime.year);
    final safeClientName = client.fullName
        .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    final date = visit.dateTime.toIso8601String().split('T').first;
    final docType = visit.paid ? 'Receipt' : 'Invoice';

    final fileName = invoiceNumber == null
        ? '${safeClientName}_${date}_$docType.pdf'
        : '$invoiceNumber.pdf';
    final file = File(p.join(output.path, fileName));
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<Directory> _invoiceDirectory(int year) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(
      documents.path,
      'invoices',
      year.toString(),
    ));

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  static pw.Widget _buildHeader(CompanyInfo company, pw.MemoryImage? logo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Company Info
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (company.name.isNotEmpty)
                pw.Text(company.name,
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              if (company.address.isNotEmpty)
                pw.Text(company.address,
                    style: const pw.TextStyle(fontSize: 10)),
              if (company.phone.isNotEmpty)
                pw.Text('Phone: ${company.phone}',
                    style: const pw.TextStyle(fontSize: 10)),
              if (company.email.isNotEmpty)
                pw.Text('Email: ${company.email}',
                    style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
        // Logo
        if (logo != null)
          pw.Container(
            width: 80,
            height: 80,
            child: pw.Image(logo, fit: pw.BoxFit.contain),
          ),
      ],
    );
  }

  static pw.Widget _tableCell(String text,
          {bool bold = false, pw.TextAlign align = pw.TextAlign.left}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(text,
            style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
            textAlign: align),
      );

  static Future<void> shareInvoice(
    File file, {
    String? subject,
    String? fileName,
  }) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject,
      text: subject ?? 'Farrier Invoice',
    );
  }

  static Future<void> printInvoice(File file) async {
    final documentName = file.path.split('/').last.replaceAll('.pdf', '');

    await Printing.layoutPdf(
      name: documentName,
      onLayout: (_) async => await file.readAsBytes(),
    );
  }
}
