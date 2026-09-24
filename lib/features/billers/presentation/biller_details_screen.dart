import 'package:flutter/material.dart';

import 'package:billbuddy/features/billers/domain/biller.dart';
import 'package:billbuddy/features/billers/domain/saved_biller.dart';

class BillerDetailsScreen extends StatelessWidget {
  const BillerDetailsScreen({
    super.key,
    required this.biller,
    required this.savedBiller,
  });

  final Biller biller;
  final SavedBiller savedBiller;

  @override
  Widget build(BuildContext context) {
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

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'No bill fetched yet.',
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fetch Bill will be implemented next.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.refresh,
                      ),
                      label: const Text(
                        'Fetch Bill',
                      ),
                    ),
                  ),
                ],
              ),
            ),
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