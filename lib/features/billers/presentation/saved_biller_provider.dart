import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/features/billers/domain/saved_biller.dart';

class SavedBillersNotifier
    extends Notifier<List<SavedBiller>> {
  @override
  List<SavedBiller> build() {
    return [];
  }

  void add(SavedBiller savedBiller) {
    state = [
      ...state,
      savedBiller,
    ];
  }
}

final savedBillersProvider =
    NotifierProvider<
        SavedBillersNotifier,
        List<SavedBiller>>(
  SavedBillersNotifier.new,
);