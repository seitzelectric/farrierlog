import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/models.dart';
import '../services/backup_service.dart';
import '../services/export_service.dart';
import '../services/invoice_service.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import 'help_screen.dart';
import 'onboarding_screen.dart';

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
  final _customCurrencyCtrl = TextEditingController();
  final _reminderCtrl = TextEditingController();
  String? _logoPath;
  bool _startCalendarWeekOnMonday = false;
  bool _exporting = false;
  bool _backingUp = false;
  bool _restoring = false;
  String _currencySymbol = '\$';
  String _distanceUnit = 'mi';
  String _terrainThemeId = 'desert';
  String _languageCode = '';
  List<ServiceTemplate> _templates = [];

  static const _presetCurrencies = [
    '\$',
    '€',
    '£',
    '¥',
    '₹',
    'CAD\$',
    'AUD\$',
    'NZD\$',
    'R',
  ];

  bool get _isCustomCurrency => !_presetCurrencies.contains(_currencySymbol);

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
    _currencySymbol = await DatabaseService.getCurrencySymbol();
    _distanceUnit = await DatabaseService.getDistanceUnit();
    _terrainThemeId = await DatabaseService.getTerrainThemeId();
    _languageCode = await DatabaseService.getLanguageCode();
    _templates = await DatabaseService.getServiceTemplates();
    _reminderCtrl.text = await DatabaseService.getReminderTemplate();

    if (_isCustomCurrency) {
      _customCurrencyCtrl.text = _currencySymbol;
    }

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
    _customCurrencyCtrl.dispose();
    _reminderCtrl.dispose();
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

  Future<void> _onLanguageChanged(String code) async {
    setState(() => _languageCode = code);
    await DatabaseService.setLanguageCode(code);
    AppUtils.applyLocale(code);
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

    final symbol = _isCustomCurrency
        ? _customCurrencyCtrl.text.trim()
        : _currencySymbol;
    await DatabaseService.setCurrencySymbol(symbol);
    AppUtils.initCurrencySymbol(symbol);

    await DatabaseService.setDistanceUnit(_distanceUnit);
    AppUtils.initDistanceUnit(_distanceUnit);

    await DatabaseService.setTerrainThemeId(_terrainThemeId);
    AppUtils.applyTerrainTheme(_terrainThemeId);

    await DatabaseService.setReminderTemplate(_reminderCtrl.text.trim());

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
      SnackBar(content: Text(AppLocalizations.of(context)!.settingsSavedSnackbar)),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.exportFailedSnackbar('$error'))),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
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
        SnackBar(content: Text(AppLocalizations.of(context)!.backupFailedSnackbar('$error'))),
      );
    } finally {
      if (mounted) setState(() => _backingUp = false);
    }
  }

  Future<void> _restoreBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreBackupTitle),
        content: Text(l10n.restoreBackupMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.restoreButton),
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
        SnackBar(content: Text(l10n.backupRestoredSnackbar)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.restoreFailedSnackbar('$error'))),
      );
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  Future<void> _deleteTemplate(ServiceTemplate template) async {
    await DatabaseService.deleteServiceTemplate(template.id!);
    final templates = await DatabaseService.getServiceTemplates();
    if (mounted) setState(() => _templates = templates);
  }

  Future<void> _addTemplateDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newServiceTemplateTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: l10n.serviceLabel),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              decoration: InputDecoration(labelText: l10n.priceLabel),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != true) return;
    final description = descCtrl.text.trim();
    if (description.isEmpty) return;
    final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
    await DatabaseService.insertServiceTemplate(
      ServiceTemplate(description: description, price: price),
    );
    final templates = await DatabaseService.getServiceTemplates();
    if (mounted) setState(() => _templates = templates);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dropdownSymbol = _isCustomCurrency ? l10n.currencyCustomOption : _currencySymbol;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(l10n.helpGuideTitle),
              subtitle: Text(l10n.helpGuideSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.languageLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _languageCode,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              DropdownMenuItem(value: '', child: Text(l10n.languageSystemDefault)),
              const DropdownMenuItem(value: 'en', child: Text('English')),
              const DropdownMenuItem(value: 'es', child: Text('Español')),
              const DropdownMenuItem(value: 'fr', child: Text('Français')),
            ],
            onChanged: (value) {
              if (value != null) _onLanguageChanged(value);
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.colorLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: terrainThemes.map((theme) {
              final isSelected = _terrainThemeId == theme.id;
              return GestureDetector(
                onTap: () => setState(() => _terrainThemeId = theme.id),
                child: Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: theme.seed,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.seed.withAlpha(120),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 22)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(l10n.companyInfoTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l10n.appearsOnInvoices,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _pickLogo,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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
              child: Text(l10n.uploadLogoButton),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
                labelText: l10n.companyNameLabel, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressCtrl,
            decoration: InputDecoration(
                labelText: l10n.addressLabel, border: const OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            decoration: InputDecoration(
                labelText: l10n.phoneLabel, border: const OutlineInputBorder()),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            decoration: InputDecoration(
                labelText: l10n.emailLabel, border: const OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          Text(l10n.currencyUnitsTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: dropdownSymbol,
            decoration: InputDecoration(
              labelText: l10n.currencyLabel,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: '\$', child: Text(l10n.currencyUsd)),
              DropdownMenuItem(value: '€', child: Text(l10n.currencyEur)),
              DropdownMenuItem(value: '£', child: Text(l10n.currencyGbp)),
              DropdownMenuItem(value: '¥', child: Text(l10n.currencyJpy)),
              DropdownMenuItem(value: '₹', child: Text(l10n.currencyInr)),
              DropdownMenuItem(value: 'CAD\$', child: Text(l10n.currencyCad)),
              DropdownMenuItem(value: 'AUD\$', child: Text(l10n.currencyAud)),
              DropdownMenuItem(value: 'NZD\$', child: Text(l10n.currencyNzd)),
              DropdownMenuItem(value: 'R', child: Text(l10n.currencyZar)),
              DropdownMenuItem(value: 'Custom...', child: Text(l10n.currencyCustomOption)),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                if (value == 'Custom...') {
                  _currencySymbol = _customCurrencyCtrl.text.trim().isEmpty
                      ? 'Custom...'
                      : _customCurrencyCtrl.text.trim();
                } else {
                  _currencySymbol = value;
                  _customCurrencyCtrl.clear();
                }
              });
            },
          ),
          if (_isCustomCurrency || dropdownSymbol == l10n.currencyCustomOption) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _customCurrencyCtrl,
              decoration: InputDecoration(
                labelText: l10n.customCurrencySymbolLabel,
                hintText: l10n.customCurrencySymbolHint,
                border: const OutlineInputBorder(),
              ),
              maxLength: 5,
              onChanged: (v) => setState(() => _currencySymbol = v.trim()),
            ),
          ],
          const SizedBox(height: 12),
          Text(l10n.distanceUnitLabel,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'mi', label: Text(l10n.distanceMiles)),
              ButtonSegment(value: 'km', label: Text(l10n.distanceKm)),
            ],
            selected: {_distanceUnit},
            onSelectionChanged: (selection) =>
                setState(() => _distanceUnit = selection.first),
          ),
          const SizedBox(height: 24),
          Text(l10n.mileageTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l10n.mileageSubtitle,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(
            controller: _mileageRateCtrl,
            decoration: InputDecoration(
              labelText: l10n.mileageRateLabel(_distanceUnit),
              prefixText: _isCustomCurrency
                  ? _customCurrencyCtrl.text.trim()
                  : _currencySymbol,
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),
          Text(l10n.calendarTitle, style: Theme.of(context).textTheme.titleLarge),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.startWeekMondaySwitch),
            value: _startCalendarWeekOnMonday,
            onChanged: (value) {
              setState(() => _startCalendarWeekOnMonday = value);
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.reminderMessageTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _reminderCtrl,
            decoration: InputDecoration(
              labelText: l10n.reminderTemplateLabel,
              border: const OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.reminderTemplateHelp('{name}', '{date}', '{time}'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(l10n.saveSettingsButton),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.serviceTemplatesTitle,
                  style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                onPressed: _addTemplateDialog,
                icon: const Icon(Icons.add_circle_outline),
                tooltip: l10n.addTemplateTooltip,
              ),
            ],
          ),
          if (_templates.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(l10n.noSavedTemplates,
                  style: Theme.of(context).textTheme.bodySmall),
            )
          else
            ..._templates.map((template) => Dismissible(
                  key: ValueKey('template-${template.id}'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteTemplate(template),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(template.description),
                    subtitle: Text(AppUtils.formatCurrency(template.price)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteTemplate(template),
                    ),
                  ),
                )),
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
            label: Text(_exporting ? l10n.exportingButton : l10n.exportDataButton),
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
            label: Text(_backingUp ? l10n.creatingBackupButton : l10n.createBackupButton),
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
            label: Text(_restoring ? l10n.restoringButton : l10n.restoreBackupButton),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.showWelcomeGuideAgain),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
