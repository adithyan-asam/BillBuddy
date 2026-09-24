import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:billbuddy/features/auth/domain/user.dart';
import 'package:billbuddy/features/auth/presentation/auth_provider.dart';
import 'package:billbuddy/features/auth/presentation/login_screen.dart';
import 'package:billbuddy/features/home/presentation/home_screen.dart';
import 'package:billbuddy/features/auth/presentation/signup_screen.dart';
import 'package:billbuddy/features/billers/domain/biller.dart';
import 'package:billbuddy/features/billers/presentation/biller_directory_screen.dart';
import 'package:billbuddy/features/billers/presentation/biller_list_screen.dart';
import 'package:billbuddy/features/billers/presentation/add_biller_screen.dart';
import 'package:billbuddy/features/billers/presentation/biller_provider.dart';
import 'package:billbuddy/features/billers/presentation/my_billers_screen.dart';
import 'package:billbuddy/features/billers/presentation/biller_details_screen.dart';
import 'package:billbuddy/features/billers/presentation/saved_biller_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final authState = ref.read(authProvider);

      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.hasValue && authState.value != null;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/billers',
        builder: (context, state) => const BillerDirectoryScreen(),
      ),
      GoRoute(
        path: '/billers/:category',
        builder: (context, state) {
          final categoryName = state.pathParameters['category'];

          final category = BillerCategory.values.firstWhere(
            (category) => category.name == categoryName,
          );

          return BillerListScreen(category: category);
        },
      ),
      GoRoute(
        path: '/billers/:category/add/:billerId',
        builder: (context, state) {
          final billerId = state.pathParameters['billerId'];

          final billersAsync = ref.read(billersProvider);

          if (!billersAsync.hasValue) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final billers = billersAsync.value!;

          final biller = billers.firstWhere((biller) => biller.id == billerId);

          return AddBillerScreen(biller: biller);
        },
      ),
      GoRoute(
        path: '/my-billers',
        builder: (context, state) => const MyBillersScreen(),
      ),
      GoRoute(
        path: '/my-billers/:id',
        builder: (context, state) {
          final savedBillerId = state.pathParameters['id'];

          final savedBillers = ref.read(savedBillersProvider);

          final savedBiller = savedBillers.firstWhere(
            (biller) => biller.id == savedBillerId,
          );

          final billersAsync = ref.read(billersProvider);

          if (!billersAsync.hasValue) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final billers = billersAsync.value!;

          final biller = billers.firstWhere(
            (biller) => biller.id == savedBiller.billerId,
          );

          return BillerDetailsScreen(biller: biller, savedBiller: savedBiller);
        },
      ),
    ],
  );

  ref.listen<AsyncValue<User?>>(authProvider, (_, _) {
    router.refresh();
  });

  ref.onDispose(router.dispose);

  return router;
});
