import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/features/billers/domain/biller.dart';
import 'package:billbuddy/features/billers/domain/saved_biller.dart';
import 'package:billbuddy/features/billers/presentation/saved_biller_provider.dart';

class AddBillerScreen extends ConsumerStatefulWidget {
  const AddBillerScreen({super.key, required this.biller});

  final Biller biller;

  @override
  ConsumerState<AddBillerScreen> createState() => _AddBillerScreenState();
}

class _AddBillerScreenState extends ConsumerState<AddBillerScreen> {
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();

  late final Map<String, TextEditingController> _fieldControllers;

  @override
  void initState() {
    super.initState();

    _fieldControllers = {
      for (final field in widget.biller.fields)
        field.key: TextEditingController(),
    };
  }

  @override
  void dispose() {
    _nicknameController.dispose();

    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Biller')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.biller.name,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              '${_categoryLabel(widget.biller.category)} • ${widget.biller.state}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 28),

            Text(
              'Biller Details',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Dynamic biller fields
            ...widget.biller.fields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: _fieldControllers[field.key],
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: field.label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';

                    if (text.isEmpty) {
                      return '${field.label} is required';
                    }

                    final regex = RegExp(field.regex);

                    if (!regex.hasMatch(text)) {
                      return 'Enter a valid ${field.label.toLowerCase()}';
                    }

                    return null;
                  },
                ),
              );
            }),

            const SizedBox(height: 4),

            // Nickname
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
                hintText: 'e.g. Home Electricity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nickname is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _addBiller,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Biller', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addBiller() async {
    if (_isSubmitting) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final fieldValues = <String, String>{};

    for (final field in widget.biller.fields) {
      fieldValues[field.key] = _fieldControllers[field.key]!.text.trim();
    }

    final savedBiller = SavedBiller(
      id: '',
      billerId: widget.biller.id,
      nickname: _nicknameController.text.trim(),
      fields: fieldValues,
    );

    try {
      await ref.read(savedBillersProvider.notifier).add(savedBiller);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Biller added successfully.')),
        );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _categoryLabel(BillerCategory category) {
    switch (category) {
      case BillerCategory.electricity:
        return 'Electricity';

      case BillerCategory.water:
        return 'Water';

      case BillerCategory.gas:
        return 'Gas';

      case BillerCategory.broadband:
        return 'Broadband';

      case BillerCategory.mobile:
        return 'Mobile';

      case BillerCategory.dth:
        return 'DTH';

      case BillerCategory.creditCard:
        return 'Credit Card';
    }
  }
}
