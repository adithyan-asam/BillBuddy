import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/features/billers/domain/biller.dart';
import 'package:billbuddy/features/billers/presentation/biller_provider.dart';
import 'package:go_router/go_router.dart';

class BillerListScreen extends ConsumerWidget {
  const BillerListScreen({super.key, required this.category});

  final BillerCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billersAsync = ref.watch(billersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_categoryLabel(category))),
      body: billersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stackTrace) => Center(
          child: FilledButton(
            onPressed: () {
              ref.invalidate(billersProvider);
            },
            child: const Text('Try again'),
          ),
        ),

        data: (billers) {
          final categoryBillers = billers
              .where((biller) => biller.category == category)
              .toList();

          if (categoryBillers.isEmpty) {
            return const Center(child: Text('No billers available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryBillers.length,
            itemBuilder: (context, index) {
              final biller = categoryBillers[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(child: Icon(_categoryIcon(category))),
                  title: Text(
                    biller.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(biller.state),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/billers/${category.name}/add/${biller.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
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

  IconData _categoryIcon(BillerCategory category) {
    switch (category) {
      case BillerCategory.electricity:
        return Icons.bolt;

      case BillerCategory.water:
        return Icons.water_drop;

      case BillerCategory.gas:
        return Icons.local_fire_department;

      case BillerCategory.broadband:
        return Icons.wifi;

      case BillerCategory.mobile:
        return Icons.phone_android;

      case BillerCategory.dth:
        return Icons.tv;

      case BillerCategory.creditCard:
        return Icons.credit_card;
    }
  }
}
