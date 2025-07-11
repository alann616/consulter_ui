import 'dart:io';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';

// --- Widget de ayuda para formatear fechas ---
String formatDate(DateTime? date) {
  if (date == null) return 'No especificada';
  return DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es_MX').format(date);
}

class PatientDetailScreen extends ConsumerWidget {
  final String? patientId;
  const PatientDetailScreen({this.patientId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectivePatientId =
        patientId ?? ref.watch(selectedPatientIdProvider);

    if (effectivePatientId == null) {
      return const fluent.Center(
        child: fluent.Column(
          mainAxisAlignment: fluent.MainAxisAlignment.center,
          children: [
            Icon(fluent.FluentIcons.contact_info, size: 48),
            fluent.SizedBox(height: 12),
            Text('Seleccione un paciente para ver su información'),
          ],
        ),
      );
    }

    final patientDetailsAsync =
        ref.watch(patientDetailsProvider(effectivePatientId));

    // El .when ahora decide qué layout de DETALLE construir
    return patientDetailsAsync.when(
      data: (patient) {
        if (Platform.isWindows) {
          return fluent.ScaffoldPage(
            header: fluent.PageHeader(
              title: Text('ID del Paciente: #${patient.patientId}'),
              // El 'leading' se quita de aquí porque ahora se maneja globalmente
            ),
            content: _WindowsPatientDetails(patient: patient),
          );
        } else {
          return _AndroidPatientDetails(patient: patient);
        }
      },
      loading: () => Platform.isWindows
          ? const fluent.Center(child: fluent.ProgressRing())
          : const material.Center(child: material.CircularProgressIndicator()),
      error: (error, _) =>
          fluent.Center(child: Text('Error al cargar detalles: $error')),
    );
  }
}

// =========================================================================
// ===             VISTA DE DETALLES PARA WINDOWS (FLUENT)               ===
// =========================================================================
class _WindowsPatientDetails extends StatelessWidget {
  final PatientModel patient;
  const _WindowsPatientDetails({required this.patient});

  @override
  Widget build(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    final fullName =
        '${patient.name} ${patient.lastName} ${patient.secondLastName ?? ''}';
    final age = DateTime.now().year - (patient.birthDate?.year ?? 0);
    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: Text(fullName),

        // Aquí podríamos añadir botones de acción (Editar, Eliminar) en el futuro
      ),
      content: fluent.ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          fluent.InfoLabel(
              label: 'Edad:',
              child: Text('$age años', style: theme.typography.bodyLarge)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Fecha de nacimiento:',
            child: Text(formatDate(patient.birthDate),
                style: theme.typography.bodyLarge),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Teléfono:',
            child: Text(
                patient.phone?.trim().isEmpty == true || patient.phone == null
                    ? 'No especificado'
                    : patient.phone!,
                style: theme.typography.bodyLarge),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Correo electrónico:',
            child: Text(
                patient.email?.trim().isEmpty == true || patient.email == null
                    ? 'No especificado'
                    : patient.email!,
                style: theme.typography.bodyLarge),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Género:',
            child: Text(
                patient.gender?.toString().split('.').last == 'MALE'
                    ? 'Masculino'
                    : 'Femenino',
                style: theme.typography.bodyLarge),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Alergias:',
            child: Text(patient.allergies ?? 'Negadas',
                style: theme.typography.bodyLarge),
          ),
          const SizedBox(height: 24),
          const fluent.Divider(),
          const SizedBox(height: 16),
          // Placeholder para futuras secciones
          Text('Historial Clínico y Notas de Evolución',
              style: theme.typography.subtitle),
        ],
      ),
    );
  }
}

// =========================================================================
// ===            VISTA DE DETALLES PARA ANDROID (MATERIAL)              ===
// =========================================================================
class _AndroidPatientDetails extends StatelessWidget {
  final PatientModel patient;
  const _AndroidPatientDetails({required this.patient});

  @override
  Widget build(BuildContext context) {
    final fullName =
        '${patient.name} ${patient.lastName} ${patient.secondLastName ?? ''}';

    return material.Scaffold(
      appBar: material.AppBar(title: Text(fullName)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          material.ListTile(
            leading: const Icon(material.Icons.phone_outlined),
            title: const Text('Teléfono'),
            subtitle: Text(patient.phone ?? 'No especificado'),
          ),
          material.ListTile(
            leading: const Icon(material.Icons.email_outlined),
            title: const Text('Correo electrónico'),
            subtitle: Text(patient.email ?? 'No especificado'),
          ),
          material.ListTile(
            leading: const Icon(material.Icons.cake_outlined),
            title: const Text('Fecha de nacimiento'),
            subtitle: Text(formatDate(patient.birthDate)),
          ),
          material.ListTile(
            leading: const Icon(material.Icons.person_outline),
            title: const Text('Género'),
            subtitle: Text(patient.gender?.toString().split('.').last == 'MALE'
                ? 'Masculino'
                : 'Femenino'),
          ),
          material.ListTile(
            leading: const Icon(material.Icons.warning_amber_outlined),
            title: const Text('Alergias'),
            subtitle: Text(patient.allergies ?? 'Ninguna especificada'),
          ),
        ],
      ),
    );
  }
}
