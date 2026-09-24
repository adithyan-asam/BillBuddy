import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:billbuddy/features/billers/domain/biller.dart';
import 'package:billbuddy/features/billers/presentation/biller_provider.dart';

class BillerDirectoryScreen extends ConsumerStatefulWidget {
  const BillerDirectoryScreen({super.key});

  @override
  ConsumerState<BillerDirectoryScreen> createState() =>
      _BillerDirectoryScreenState();
}

class _BillerDirectoryScreenState
    extends ConsumerState<BillerDirectoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final billersAsync = ref.watch(billersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billers'),
      ),
      body: billersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stackTrace) => _ErrorView(
          onRetry: () {
            ref.invalidate(billersProvider);
          },
        ),

        data: (billers) {
          final query =
              _searchController.text.trim().toLowerCase();

          final filteredBillers = billers.where((biller) {
            return biller.name
                    .toLowerCase()
                    .contains(query) ||
                biller.state
                    .toLowerCase()
                    .contains(query);
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(billersProvider);
              await ref.read(billersProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search billers',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (query.isEmpty) ...[
                  Text(
                    'Categories',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount:
                        BillerCategory.values.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.35,
                    ),
                    itemBuilder: (context, index) {
                      final category =
                          BillerCategory.values[index];

                      return _CategoryCard(
                        category: category,
                        onTap: () {
                          context.push(
                            '/billers/${category.name}',
                          );
                        },
                      );
                    },
                  ),
                ] else ...[
                  Text(
                    'Search Results',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  if (filteredBillers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No billers found.',
                        ),
                      ),
                    )
                  else
                    ...filteredBillers.map(
                      (biller) {
                        return Card(
                          margin:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                _categoryIcon(
                                  biller.category,
                                ),
                              ),
                            ),
                            title: Text(
                              biller.name,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              biller.state,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                            ),
                            onTap: () {
                              context.push(
                                '/billers/${biller.category.name}/add/${biller.id}',
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final BillerCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                child: Icon(
                  _categoryIcon(category),
                  size: 28,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                _categoryLabel(category),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Unable to load billers.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
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