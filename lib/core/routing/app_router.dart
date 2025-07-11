import 'package:consulter_ui/features/auth/providers/auth_provider.dart';
import 'package:consulter_ui/features/auth/screens/profile_selection_screen.dart';
import 'package:consulter_ui/features/patients/screens/patient_detail_screen.dart';
import 'package:consulter_ui/features/home/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. Creamos un provider para nuestro enrutador
final routerProvider = Provider<GoRouter>((ref) {
  // Observamos el estado de autenticación
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login', // Intentamos ir a home al inicio
    debugLogDiagnostics: true, // Útil para depurar la navegación

    // 2. Definimos nuestras rutas
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const ProfileSelectionScreen(),
      ),
      GoRoute(
          path: '/home',
          // Asegúrate de que esto apunte a MainScreen
          builder: (context, state) => const MainScreen(),
          routes: [
            GoRoute(
              path: 'patient/:patientId', // Se accederá como /home/patient/123
              builder: (context, state) {
                // Extraemos el ID del paciente desde la URL
                final patientId = state.pathParameters['patientId']!;
                return PatientDetailScreen(patientId: patientId);
              },
            )
          ]),
    ],

    // 3. Lógica de redirección
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.asData?.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // Si el usuario no ha iniciado sesión y no está en la página de login,
      // lo redirigimos a /login.
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // Si el usuario ya inició sesión y está en la página de login,
      // lo llevamos a /home.
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      // En cualquier otro caso, no hacemos nada.
      return null;
    },
  );
});
