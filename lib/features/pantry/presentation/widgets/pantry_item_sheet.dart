import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/pantry_providers.dart';
import '../../domain/pantry_item.dart';

/// Presents the add/edit sheet. Pass [existing] to edit, omit it to create.
///
/// A free function rather than a static: the caller should not need to know
/// which widget class implements the sheet.
Future<void> showPantryItemSheet(BuildContext context, {PantryItem? existing}) {
  return showModalBottomSheet<void>(
    context: context,
    // Lets the sheet grow past half-height and sit above the keyboard.
    isScrollControlled: true,
    builder: (_) => _PantryItemSheet(existing: existing),
  );
}

/// ConsumerStatefulWidget = StatefulWidget + `ref`. Needed here because the
/// form owns mutable controller state *and* reads a provider.
class _PantryItemSheet extends ConsumerStatefulWidget {
  const _PantryItemSheet({this.existing});

  final PantryItem? existing;

  @override
  ConsumerState<_PantryItemSheet> createState() => _PantryItemSheetState();
}

class _PantryItemSheetState extends ConsumerState<_PantryItemSheet> {
  /// Handle to the Form, used to trigger validation on submit.
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late StorageLocation _location;
  late DateTime _expiresOn;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController =
        TextEditingController(text: (item?.quantity ?? 1).toString());
    _location = item?.location ?? StorageLocation.cupboard;
    // Default to a week out — a sensible guess beats an empty required field.
    _expiresOn = item?.expiresOn ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    // Controllers hold native resources. Forgetting this is a real leak, and
    // Flutter will tell you about it in debug mode.
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  /// Opens the platform date picker and stores the result.
  ///
  /// Note the shape: an async call that returns a value, then setState. This
  /// is Flutter's idiom for any modal that produces data.
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresOn,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _expiresOn = picked);
  }

  /// Validates, builds the entity, saves, and closes.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final item = PantryItem(
      // Preserving the id is what makes this an update rather than an insert.
      id: widget.existing?.id,
      name: _nameController.text.trim(),
      quantity: int.parse(_quantityController.text),
      location: _location,
      expiresOn: DateTime(_expiresOn.year, _expiresOn.month, _expiresOn.day),
    );

    await ref.read(pantryActionsProvider).save(item);

    // `mounted` guards against the sheet being dismissed during the await.
    // Skipping this check is the most common async-gap crash in Flutter.
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lifts the sheet above the keyboard.
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? 'Edit item' : 'Add item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              autofocus: !_isEditing,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.sentences,
              // Validators return null for valid, a message for invalid.
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Give it a name'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final n = int.tryParse(value ?? '');
                return (n == null || n < 1) ? 'Must be 1 or more' : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<StorageLocation>(
              initialValue: _location,
              decoration: const InputDecoration(labelText: 'Location'),
              items: StorageLocation.values
                  .map((l) => DropdownMenuItem(value: l, child: Text(l.name)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _location = value ?? _location),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Expires'),
              subtitle: Text(DateFormat.yMMMMd().format(_expiresOn)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}