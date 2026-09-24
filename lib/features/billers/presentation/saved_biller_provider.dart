import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billbuddy/features/auth/presentation/auth_provider.dart';
import 'package:billbuddy/features/billers/data/saved_biller_repository.dart';
import 'package:billbuddy/features/billers/domain/saved_biller.dart';

final savedBillerRepositoryProvider =
    Provider<SavedBillerRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);

  return SavedBillerRepository(dioClient);
});

class SavedBillersNotifier
    extends AsyncNotifier<List<SavedBiller>> {

  @override
  Future<List<SavedBiller>> build() async {
    final repository =
        ref.read(savedBillerRepositoryProvider);

    return repository.getSavedBillers();
  }

  Future<void> add(SavedBiller savedBiller) async {
    final repository =
        ref.read(savedBillerRepositoryProvider);

    final savedBillerFromServer =
        await repository.addBiller(savedBiller);

    final currentBillers = state.value ?? [];

    state = AsyncData([
      ...currentBillers,
      savedBillerFromServer,
    ]);
  }
}

final savedBillersProvider =
    AsyncNotifierProvider<SavedBillersNotifier, List<SavedBiller>>(
  SavedBillersNotifier.new,
);