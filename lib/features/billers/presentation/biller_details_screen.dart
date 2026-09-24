import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/features/billers/domain/biller.dart';
import 'package:billbuddy/features/billers/domain/saved_biller.dart';
import 'package:billbuddy/features/billers/presentation/bill_provider.dart';

class BillerDetailsScreen extends ConsumerWidget {
  const BillerDetailsScreen({
    super.key,
    required this.biller,
    required this.savedBiller,
  });

  final Biller biller;
  final SavedBiller savedBiller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billAsync = ref.watch(
      billProvider(savedBiller.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(savedBiller.nickname),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            biller.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 8),

          Text(
            '${_categoryLabel(biller.category)} • ${biller.state}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 28),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Details',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  ...biller.fields.map(
                    (field) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                field.label,
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                savedBiller
                                        .fields[field.key] ??
                                    '-',
                                textAlign:
                                    TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Bill',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          billAsync.when(
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

            error: (error, stackTrace) => Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Unable to fetch your bill.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(
                          billProvider(savedBiller.id),
                        );
                      },
                      icon: const Icon(
                        Icons.refresh,
                      ),
                      label: const Text(
                        'Retry',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            data: (bill) {
              if (bill == null || !bill.isDue) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No bill is currently due.',
                      ),
                    ),
                  ),
                );
              }

              return _BillCard(
                amount: bill.amount,
                dueDate: bill.dueDate,
                billingPeriod: bill.billingPeriod,
              );
            },
          ),
        ],
      ),
    );
  }

  String _categoryLabel(
    BillerCategory category,
  ) {
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

class _BillCard extends StatelessWidget {
  const _BillCard({
    required this.amount,
    required this.dueDate,
    required this.billingPeriod,
  });

  final double amount;
  final DateTime dueDate;
  final String billingPeriod;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Current Due',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),

            const SizedBox(height: 8),

            Text(
              '₹${amount.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 16),

            _BillInfoRow(
              label: 'Due Date',
              value: _formatDate(dueDate),
            ),

            const SizedBox(height: 12),

            _BillInfoRow(
              label: 'Billing Period',
              value: billingPeriod,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pay Bill will be implemented next.',
                        ),
                      ),
                    );
                },
                icon: const Icon(
                  Icons.payment,
                ),
                label: const Text(
                  'Pay Bill',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillInfoRow extends StatelessWidget {
  const _BillInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(value),
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}