import 'dart:io';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:consulter_ui/features/patients/widgets/patient_form_dialog.dart';

// --- Widget de ayuda para obtener iniciales ---
String getInitials(String name, String lastName) {
  if (name.isEmpty && lastName.isEmpty) return '??';
  final String firstNameInitial = name.isNotEmpty ? name[0] : '';
  final String lastNameInitial = lastName.isNotEmpty ? lastName[0] : '';
  return '$firstNameInitial$lastNameInitial'.toUpperCase();
}

class PatientListScreen extends ConsumerWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // La lógica de carga de datos sigue siendo la misma
    final patientsAsyncValue = ref.watch(allPatientsProvider);

    return patientsAsyncValue.when(
      data: (patients) {
        if (Platform.isWindows) {
          return _WindowsPatientListView(patients: patients);
        } else {
          return _AndroidPatientListView(patients: patients);
        }
      },
      loading: () => Platform.isWindows
          ? const fluent.Center(child: fluent.ProgressRing())
          : const material.Center(child: material.CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

// =========================================================================
// ===             VISTA DE LISTA PARA WINDOWS (FLUENT UI)               ===
// =========================================================================
class _WindowsPatientListView extends ConsumerWidget {
  final List<PatientModel> patients;
  const _WindowsPatientListView({required this.patients});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return fluent.Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // --- Encabezado ---
          Row(
            children: [
              Expanded(
                child: Text('Pacientes',
                    style: fluent.FluentTheme.of(context).typography.title),
              ),
              fluent.Tooltip(
                message: 'Añadir nuevo paciente',
                child: fluent.FilledButton(
                  child: const Row(children: [
                    Icon(fluent.FluentIcons.add),
                    SizedBox(width: 8),
                    Text('Nuevo')
                  ]),
                  onPressed: () {
                    fluent.showDialog(
                      context: context,
                      builder: (context) => const PatientFormDialog(),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              fluent.Tooltip(
                message: 'Ordenar y filtrar',
                child: fluent.IconButton(
                  icon: const Icon(fluent.FluentIcons.filter),
                  onPressed: () {/* TODO: Lógica de filtros */},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // --- ¡BUSCADOR RESTAURADO! ---
          const fluent.TextBox(
            placeholder: 'Buscar paciente...',
            prefix: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(fluent.FluentIcons.search)),
          ),
          const SizedBox(height: 12),

          // --- Lista de Pacientes ---
          Expanded(
            child: patients.isEmpty
                ? const Center(child: Text('No se encontraron pacientes.'))
                : fluent.ListView.builder(
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];
                      return _PatientListTile(patient: patient);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PatientListTile extends ConsumerWidget {
  final PatientModel patient;
  const _PatientListTile({required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPatientId = ref.watch(selectedPatientIdProvider);
    final isSelected = selectedPatientId == patient.patientId;

    return fluent.ListTile(
      title: Text(
          '${patient.name} ${patient.lastName} ${patient.secondLastName ?? ''}'),
      subtitle: Text(patient.phone ?? 'Sin teléfono'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      leading: fluent.CircleAvatar(
        radius: 20,
        backgroundColor: fluent.FluentTheme.of(context).accentColor.normal,
        child: Text(
          getInitials(patient.name ?? '', patient.lastName ?? ''),
          style: const TextStyle(
              color: material.Colors.white,
              fontWeight: material.FontWeight.bold),
        ),
      ),
      onPressed: () {
        // En Windows, solo actualizamos el estado.
        // La vista de detalle reaccionará a este cambio.
        ref.read(selectedPatientIdProvider.notifier).state =
            patient.patientId?.toString();
      },
    );
  }
}

// =========================================================================
// ===             VISTA DE LISTA PARA ANDROID (MATERIAL)                ===
// =========================================================================
class _AndroidPatientListView extends StatelessWidget {
  final List<PatientModel> patients;
  const _AndroidPatientListView({required this.patients});

  @override
  Widget build(BuildContext context) {
    return material.ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return material.ListTile(
          leading: material.CircleAvatar(
            child:
                Text(getInitials(patient.name ?? '', patient.lastName ?? '')),
          ),
          title: Text('${patient.name} ${patient.lastName}'),
          subtitle: Text(patient.phone ?? 'Sin teléfono'),
          onTap: () {
            // En Android, navegamos a una pantalla diferente
            context.go('/home/patient/${patient.patientId}');
          },
        );
      },
    );
  }
}
