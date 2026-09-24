import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:billbuddy/features/billers/presentation/saved_biller_provider.dart';

class MyBillersScreen extends ConsumerWidget {
  const MyBillersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedBillersAsync = ref.watch(savedBillersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Billers'),
      ),
      body: savedBillersAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Failed to load billers.',
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(savedBillersProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        data: (savedBillers) {
          if (savedBillers.isEmpty) {
            return const Center(
              child: Text('No billers added yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedBillers.length,
            itemBuilder: (context, index) {
              final biller = savedBillers[index];

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.receipt_long),
                  ),
                  title: Text(
                    biller.nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    biller.billerId,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    context.push(
                      '/my-billers/${biller.id}',
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}