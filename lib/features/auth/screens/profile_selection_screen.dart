import 'package:consulter_ui/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider local para manejar qué licencia está seleccionada en la UI
final selectedLicenseProvider = StateProvider<String?>((ref) => null);

class ProfileSelectionScreen extends ConsumerWidget {
  const ProfileSelectionScreen({super.key});

  // Basado en tu DataInitializer.java, mapeamos nombres a licencias
  //
  final Map<String, String> _users = const {
    'Carlos Eduardo Martínez Vielma': '11810523',
    'Vicente Martínez Fragoso': '729376',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLicense = ref.watch(selectedLicenseProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Container(
            margin: const EdgeInsets.all(24.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Consulter',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Seleccione su perfil para continuar',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 32),

                // Generamos los botones de radio desde nuestro mapa de usuarios
                ..._users.entries.map((entry) => RadioListTile<String>(
                      title: Text(entry.key),
                      value: entry.value, // El valor es la licencia
                      groupValue: selectedLicense,
                      onChanged: (value) {
                        ref.read(selectedLicenseProvider.notifier).state =
                            value;
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                    )),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 0,
                    ),
                    // El botón se habilita solo si se ha seleccionado un usuario y no está cargando
                    onPressed: selectedLicense == null || authState.isLoading
                        ? null
                        : () {
                            // Al presionar, llamamos a la lógica de login con la licencia seleccionada
                            ref
                                .read(authNotifierProvider.notifier)
                                .login(selectedLicense);
                          },
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Ingresar',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
