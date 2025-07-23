// lib/features/patients/screens/patient_list_screen.dart

import 'dart:io';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/auth/providers/patient_filter_provider.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:consulter_ui/features/patients/widgets/patient_form_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart'
    show showMenu, PopupMenuItem, RelativeRect;

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
    if (Platform.isWindows) {
      return const _WindowsPatientListView();
    } else {
      return const _AndroidPatientListView(); // Implementación para Android
    }
  }
}

class _WindowsPatientListView extends ConsumerWidget {
  const _WindowsPatientListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPatients = ref.watch(filteredAndSortedPatientsProvider);
    final sortOption = ref.watch(patientSortProvider);

    return fluent.Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Pacientes',
                      style: fluent.FluentTheme.of(context).typography.title)),
              fluent.FilledButton(
                child: const Row(children: [
                  Icon(fluent.FluentIcons.add),
                  SizedBox(width: 8),
                  Text('Nuevo')
                ]),
                onPressed: () => fluent.showDialog(
                    context: context,
                    builder: (_) => const PatientFormDialog()),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: fluent.TextBox(
                  placeholder: 'Buscar pacientes...',
                  onChanged: (value) =>
                      ref.read(patientSearchProvider.notifier).state = value,
                ),
              ),
              const SizedBox(width: 12),
              fluent.DropDownButton(
                title: const Icon(fluent.FluentIcons.filter),
                items: SortOption.values
                    .map((option) => fluent.MenuFlyoutItem(
                          text: Text(_getSortOptionText(option)),
                          leading: sortOption == option
                              ? const Icon(fluent.FluentIcons.check_mark,
                                  size: 16)
                              : null,
                          onPressed: () => ref
                              .read(patientSortProvider.notifier)
                              .state = option,
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: asyncPatients.when(
              loading: () => const fluent.Center(child: fluent.ProgressRing()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (patients) {
                if (patients.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron pacientes.'),
                  );
                }

                return fluent.ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) =>
                      _PatientListTile(patient: patients[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.registrationNewest:
        return 'Registro: Más reciente';
      case SortOption.registrationOldest:
        return 'Registro: Más antiguo';
      case SortOption.ageDesc:
        return 'Edad: Mayor a menor';
      case SortOption.ageAsc:
        return 'Edad: Menor a mayor';
    }
  }
}

// El ListTile y la vista de Android no necesitan cambios.
// Su código actual es correcto.
class _PatientListTile extends ConsumerWidget {
  final PatientModel patient;
  const _PatientListTile({required this.patient});

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
    fluent.showDialog(
      context: context,
      builder: (dialogContext) => fluent.ContentDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${patient.name} ${patient.lastName}? Esta acción no se puede deshacer.',
        ),
        actions: [
          fluent.Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          fluent.FilledButton(
            style: fluent.ButtonStyle(
                backgroundColor: fluent.ButtonState.all(fluent.Colors.red)),
            child: const Text('Eliminar'),
            onPressed: () {
              ref
                  .read(patientNotifierProvider.notifier)
                  .deletePatient(patient.patientId!.toString());
              Navigator.pop(dialogContext);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPatientId = ref.watch(selectedPatientIdProvider);
    final isSelected = selectedPatientId == patient.patientId?.toString();
    final theme = fluent.FluentTheme.of(context);

    return fluent.GestureDetector(
      onSecondaryTapUp: (details) {
        final targetContext = context;
        final position = details.globalPosition;
        final RenderBox overlay = Navigator.of(targetContext)
            .overlay!
            .context
            .findRenderObject() as RenderBox;

        showMenu<int>(
          context: targetContext,
          position: RelativeRect.fromRect(
            position & const Size(1, 1),
            Offset.zero & overlay.size,
          ),
          items: [
            const PopupMenuItem(
              value: 1,
              child: Text('Eliminar Paciente'),
            ),
          ],
        ).then((value) {
          if (value == 1) {
            _showDeleteConfirmationDialog(context, ref);
          }
        });
      },
      child: fluent.ListTile(
        title: Text(
            '${patient.name} ${patient.lastName} ${patient.secondLastName ?? ''}'),
        subtitle: Text(patient.phone ?? 'Sin teléfono'),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        leading: fluent.CircleAvatar(
          radius: 20,
          backgroundColor: theme.accentColor.normal,
          child: Text(
            getInitials(patient.name ?? '', patient.lastName ?? ''),
            style: const TextStyle(
                color: material.Colors.white,
                fontWeight: material.FontWeight.bold),
          ),
        ),
        tileColor: isSelected
            ? fluent.WidgetStateProperty.all(theme.accentColor.lighter
                .withValues(
                    alpha: 0.2)) // Color más claro para el fondo seleccionado
            : null,
        onPressed: () {
          ref.read(selectedPatientIdProvider.notifier).state =
              patient.patientId?.toString();
        },
      ),
    );
  }
}

class _AndroidPatientListView extends ConsumerWidget {
  const _AndroidPatientListView();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Para simplificar, puedes aplicar la misma lógica aquí si lo necesitas.
    // Por ahora, lo dejamos como estaba.
    final patientsAsyncValue = ref.watch(allPatientsProvider);
    return patientsAsyncValue.when(
        loading: () =>
            const material.Center(child: material.CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (patients) => material.ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return material.ListTile(
                  leading: material.CircleAvatar(
                    child: Text(getInitials(
                        patient.name ?? '', patient.lastName ?? '')),
                  ),
                  title: Text('${patient.name} ${patient.lastName}'),
                  subtitle: Text(patient.phone ?? 'Sin teléfono'),
                  onTap: () {
                    context.go('/home/patient/${patient.patientId}');
                  },
                );
              },
            ));
  }
}
