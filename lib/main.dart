import 'dart:io' show Platform;
import 'package:consulter_ui/core/routing/app_router.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // Aseguramos que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // --- ¡NUEVA CONFIGURACIÓN DE VENTANA! ---
  // Nos aseguramos de que esta lógica solo corra en plataformas de escritorio
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(400, 300), // <-- DEFINE EL TAMAÑO MÍNIMO AQUÍ
      center: true,
      title: 'Consulter',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  // ------------------------------------------

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos la configuración del enrutador desde nuestro provider
    final router = ref.watch(routerProvider);

    // Verificamos la plataforma para construir la UI correspondiente
    if (Platform.isWindows) {
      // Usamos FluentApp para Windows
      return fluent.FluentApp.router(
        title: 'Consulter App',
        theme: fluent.FluentThemeData(
          brightness: Brightness.light,
          accentColor: fluent.Colors.teal,
          visualDensity: fluent.VisualDensity.standard,
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
    } else {
      // Usamos MaterialApp para Android, iOS, etc.
      return MaterialApp.router(
        title: 'Consulter App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF009978)),
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
    }
  }
}
