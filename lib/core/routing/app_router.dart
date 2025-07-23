// lib/core/routing/app_router.dart

import 'package:consulter_ui/features/auth/providers/auth_provider.dart';
import 'package:consulter_ui/features/auth/screens/profile_selection_screen.dart';
import 'package:consulter_ui/features/patients/screens/patient_detail_screen.dart';
import 'package:consulter_ui/features/home/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const ProfileSelectionScreen(),
      ),
      GoRoute(
          path: '/home',
          builder: (context, state) => const MainScreen(),
          routes: [
            GoRoute(
              path: 'patient/:patientId',
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return PatientDetailScreen(patientId: patientId);
              },
            )
          ]),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.asData?.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },
  );
});
