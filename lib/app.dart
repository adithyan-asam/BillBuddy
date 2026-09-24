import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/core/router/app_router.dart';
import 'package:billbuddy/core/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BillBuddy',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}