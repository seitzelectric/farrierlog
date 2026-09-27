import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/models.dart';

class ClientFormDialog extends StatefulWidget {
  final Client? client;

  /// Pre-fills the fields of a new client (ignored when [client] is set).
  final Client? prefill;

  const ClientFormDialog({
    super.key,
    this.client,
    this.prefill,
  });

  @override
  State<ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends State<ClientFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _internalNotesCtrl;

  @override
  void initState() {
    super.initState();

    final c = widget.client ?? widget.prefill;

    _firstNameCtrl = TextEditingController(text: c?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: c?.lastName ?? '');
    _phoneCtrl = TextEditingController(text: c?.phone ?? '');
    _emailCtrl = TextEditingController(text: c?.email ?? '');
    _addressCtrl = TextEditingController(text: c?.address ?? '');
    _notesCtrl = TextEditingController(text: c?.notes ?? '');
    _internalNotesCtrl = TextEditingController(text: c?.internalNotes ?? '');
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    _internalNotesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      Client(
        id: widget.client?.id,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
        internalNotes: _internalNotesCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final editing = widget.client != null;

    return AlertDialog(
      title: Text(editing ? l10n.editClientTitle : l10n.addClientTitle),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _firstNameCtrl,
                  decoration: InputDecoration(labelText: l10n.firstNameLabel),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.requiredField
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastNameCtrl,
                  decoration: InputDecoration(labelText: l10n.lastNameLabel),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.requiredField
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: InputDecoration(labelText: l10n.phoneLabel),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(labelText: l10n.emailLabel),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: InputDecoration(labelText: l10n.addressLabel),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.clientNotesLabel,
                    hintText: l10n.clientNotesHint,
                  ),
                  maxLines: 3,
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
                      hintText: l10n.internalNotesHintClient,
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Colors.amber),
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(editing ? l10n.save : l10n.add),
        ),
      ],
    );
  }
}
