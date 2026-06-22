import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/backup_service.dart';
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
  final _mileageRateCtrl = TextEditingController();
  String? _logoPath;
  bool _startCalendarWeekOnMonday = false;
  bool _exporting = false;
  bool _backingUp = false;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _nameCtrl.text = await DatabaseService.getSetting('company_name');

    _addressCtrl.text = await DatabaseService.getSetting('company_address');

    _phoneCtrl.text = await DatabaseService.getSetting('company_phone');

    _emailCtrl.text = await DatabaseService.getSetting('company_email');

    _logoPath = await DatabaseService.getSetting('company_logo');

    _startCalendarWeekOnMonday =
        await DatabaseService.getSetting('start_calendar_week_on_monday') ==
            'true';

    final mileageRate = await DatabaseService.getMileageRate();
    _mileageRateCtrl.text = mileageRate.toString();

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
    _mileageRateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 300);
    if (image != null) {
      setState(() => _logoPath = image.path);
    }
  }

  Future<void> _save() async {
    await DatabaseService.setSetting('company_name', _nameCtrl.text.trim());

    await DatabaseService.setSetting(
        'company_address', _addressCtrl.text.trim());

    await DatabaseService.setSetting('company_phone', _phoneCtrl.text.trim());

    await DatabaseService.setSetting('company_email', _emailCtrl.text.trim());

    await DatabaseService.setSetting('company_logo', _logoPath ?? '');

    await DatabaseService.setSetting(
      'start_calendar_week_on_monday',
      _startCalendarWeekOnMonday.toString(),
    );

    final mileageRate = double.tryParse(_mileageRateCtrl.text.trim()) ?? 0.67;
    await DatabaseService.setMileageRate(mileageRate);

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

  Future<void> _createBackup() async {
    setState(() => _backingUp = true);

    try {
      final file = await BackupService.createBackup();
      await BackupService.shareBackup(file);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _backingUp = false);
      }
    }
  }

  Future<void> _restoreBackup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text(
          'This will replace all current FarrierLog data on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    final path = picked?.files.single.path;
    if (path == null) return;

    setState(() => _restoring = true);

    try {
      await BackupService.restoreBackup(File(path));
      await _loadSettings();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup restored.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _restoring = false);
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
          Text('Company Information',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Appears on invoices',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _pickLogo,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                backgroundImage:
                    _logoPath != null ? FileImage(File(_logoPath!)) : null,
                child: _logoPath == null
                    ? Icon(Icons.camera_alt,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)
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
            decoration: const InputDecoration(
                labelText: 'Company Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressCtrl,
            decoration: const InputDecoration(
                labelText: 'Address', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(
                labelText: 'Phone', border: OutlineInputBorder()),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
                labelText: 'Email', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          Text('Mileage', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Default rate used when adding mileage or transport charges',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(
            controller: _mileageRateCtrl,
            decoration: const InputDecoration(
              labelText: 'Mileage Rate (per mile)',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),
          Text('Calendar', style: Theme.of(context).textTheme.titleLarge),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Start calendar week on Monday'),
            value: _startCalendarWeekOnMonday,
            onChanged: (value) {
              setState(() => _startCalendarWeekOnMonday = value);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save Settings'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
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
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _backingUp ? null : _createBackup,
            icon: _backingUp
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.backup),
            label: Text(_backingUp ? 'Creating Backup...' : 'Create Backup'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _restoring ? null : _restoreBackup,
            icon: _restoring
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.restore),
            label: Text(_restoring ? 'Restoring...' : 'Restore Backup'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
