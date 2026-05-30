import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/export_service.dart';
import '../services/invoice_service.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String? _logoPath;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
  _nameCtrl.text =
      await DatabaseService.getSetting('company_name');

  _addressCtrl.text =
      await DatabaseService.getSetting('company_address');

  _phoneCtrl.text =
      await DatabaseService.getSetting('company_phone');

  _emailCtrl.text =
      await DatabaseService.getSetting('company_email');

  _logoPath =
      await DatabaseService.getSetting('company_logo');

  if (_logoPath != null && _logoPath!.isEmpty) {
    _logoPath = null;
  }

  InvoiceService.setCompanyInfo(
    CompanyInfo(
      name: _nameCtrl.text,
      address: _addressCtrl.text,
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
      logoPath: _logoPath,
    ),
  );

  if (mounted) {
    setState(() {});
  }
}

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 300);
    if (image != null) {
      setState(() => _logoPath = image.path);
    }
  }

  Future<void> _save() async {
  await DatabaseService.setSetting(
      'company_name', _nameCtrl.text.trim());

  await DatabaseService.setSetting(
      'company_address', _addressCtrl.text.trim());

  await DatabaseService.setSetting(
      'company_phone', _phoneCtrl.text.trim());

  await DatabaseService.setSetting(
      'company_email', _emailCtrl.text.trim());

  await DatabaseService.setSetting(
      'company_logo', _logoPath ?? '');

  InvoiceService.setCompanyInfo(
    CompanyInfo(
      name: _nameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      logoPath: _logoPath,
    ),
  );

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Settings saved!')),
  );
}

  Future<void> _exportData() async {
    setState(() => _exporting = true);

    try {
      final file = await ExportService.exportCsvZip();
      await ExportService.shareCsvZip(file);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _exporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Company Information', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Appears on invoices', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _pickLogo,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                backgroundImage: _logoPath != null ? FileImage(File(_logoPath!)) : null,
                child: _logoPath == null
                    ? Icon(Icons.camera_alt, size: 30, color: Theme.of(context).colorScheme.onSurfaceVariant)
                    : null,
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _pickLogo,
              child: const Text('Upload Logo'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Company Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressCtrl,
            decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save Settings'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _exporting ? null : _exportData,
            icon: _exporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share),
            label: Text(_exporting ? 'Exporting...' : 'Export Data'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
