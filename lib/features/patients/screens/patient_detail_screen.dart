// lib/features/patients/screens/patient_detail_screen.dart

import 'dart:io';
import 'package:consulter_ui/core/models/evolution_note_model.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:consulter_ui/features/patients/widgets/clinical_history_form.dart';
import 'package:consulter_ui/features/patients/widgets/patient_form_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart'; // Asegúrate de tener esta importación
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';

import '../widgets/evolution_note_form.dart';

// --- Widget principal que decide qué layout mostrar ---
class PatientDetailScreen extends ConsumerWidget {
  final String? patientId;
  const PatientDetailScreen({this.patientId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectivePatientId =
        patientId ?? ref.watch(selectedPatientIdProvider);

    if (effectivePatientId == null) {
      // Mensaje cuando no hay ningún paciente seleccionado en Windows
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

    return patientDetailsAsync.when(
      data: (patient) {
        if (Platform.isWindows) {
          return _WindowsPatientDetailTabs(patient: patient);
        } else {
          // La versión de Android aún no tiene tabs, se puede implementar después
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
// ===     NUEVA VISTA CON PESTAÑAS PARA WINDOWS (FLUENT UI)             ===
// =========================================================================
class _WindowsPatientDetailTabs extends fluent.StatefulWidget {
  final PatientModel patient;
  const _WindowsPatientDetailTabs({required this.patient});

  @override
  fluent.State<_WindowsPatientDetailTabs> createState() =>
      _WindowsPatientDetailTabsState();
}

class _WindowsPatientDetailTabsState
    extends fluent.State<_WindowsPatientDetailTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return fluent.TabView(
      currentIndex: _currentIndex,
      onChanged: (index) => setState(() => _currentIndex = index),
      tabs: [
        fluent.Tab(
          text: const Text('Detalles'),
          icon: const Icon(fluent.FluentIcons.contact_card),
          body: _PatientDetailsTab(patient: widget.patient),
        ),
        fluent.Tab(
          text: const Text('Notas de Evolución'),
          icon: const Icon(fluent.FluentIcons.medical_care),
          body: _EvolutionNotesTab(patient: widget.patient),
        ),
        fluent.Tab(
          text: const Text('Historia Clínica'),
          icon: const Icon(fluent.FluentIcons.clinical_impression),
          body: _ClinicalHistoryTab(patient: widget.patient),
        ),
      ],
    );
  }
}

// --- Pestaña 1: Detalles del Paciente ---
class _PatientDetailsTab extends ConsumerWidget {
  final PatientModel patient;
  const _PatientDetailsTab({required this.patient});

  String formatDate(DateTime? date) {
    if (date == null) return 'No especificada';
    return DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es_MX').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = fluent.FluentTheme.of(context);
    final fullName =
        '${patient.name} ${patient.lastName} ${patient.secondLastName ?? ''}';
    final age = DateTime.now().year - (patient.birthDate?.year ?? 0);
    final ageInMonths = DateTime.now().month - (patient.birthDate?.month ?? 0);

    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: Text(fullName),
        commandBar: fluent.CommandBar(
          mainAxisAlignment: fluent.MainAxisAlignment.end,
          primaryItems: [
            fluent.CommandBarButton(
              icon: const Icon(fluent.FluentIcons.edit),
              label: const Text('Editar Información'),
              onPressed: () {
                fluent.showDialog(
                  context: context,
                  builder: (_) => PatientFormDialog(
                      patient: patient), // Se pasa el paciente actual
                );
              },
            ),
          ],
        ),
      ),
      content: fluent.ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          fluent.InfoLabel(
            label: 'ID de Paciente:',
            child: Text(patient.publicId ?? 'N/A',
                style: theme.typography.bodyLarge),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Edad:',
              child: Text(
                (age <= 0 && ageInMonths <= 1)
                    ? '$ageInMonths mes'
                    : (age <= 0)
                        ? '$ageInMonths meses'
                        : (age == 1)
                            ? '$age año'
                            : '$age años',
                style: theme.typography.bodyLarge,
              )),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Fecha de nacimiento:',
              child: Text(formatDate(patient.birthDate),
                  style: theme.typography.bodyLarge)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Teléfono:',
              child: Text(
                  patient.phone?.trim().isEmpty == true || patient.phone == null
                      ? 'No especificado'
                      : patient.phone!,
                  style: theme.typography.bodyLarge)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Correo electrónico:',
              child: Text(
                  patient.email?.trim().isEmpty == true || patient.email == null
                      ? 'No especificado'
                      : patient.email!,
                  style: theme.typography.bodyLarge)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Género:',
              child: Text(
                  patient.gender.toString().split('.').last == 'MALE'
                      ? 'Masculino'
                      : 'Femenino',
                  style: theme.typography.bodyLarge)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Alergias:',
              child: Text(patient.allergies ?? 'Negadas',
                  style: theme.typography.bodyLarge)),
        ],
      ),
    );
  }
}

// --- Pestaña 2: Notas de Evolución (Placeholder) ---
class _EvolutionNotesTab extends ConsumerStatefulWidget {
  final PatientModel patient;
  const _EvolutionNotesTab({required this.patient});

  @override
  ConsumerState<_EvolutionNotesTab> createState() => _EvolutionNotesTabState();
}

class _EvolutionNotesTabState extends ConsumerState<_EvolutionNotesTab> {
  EvolutionNoteModel? _noteToShow;
  bool _isCreatingNote = false;
  final DateFormat _tableDateFormat = DateFormat('dd/MM/yyyy hh:mm a', 'es_MX');

  void _backToList() {
    setState(() {
      _noteToShow = null;
      _isCreatingNote = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_noteToShow != null) {
      return EvolutionNoteForm(
        patient: widget.patient,
        note: _noteToShow,
        isReadOnly: true,
        onFinish: _backToList,
      );
    }

    if (_isCreatingNote) {
      return EvolutionNoteForm(
        patient: widget.patient,
        onFinish: () {
          ref.invalidate(
              evolutionNotesProvider(widget.patient.patientId!.toString()));
          _backToList();
        },
      );
    }

    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: const Text('Notas de Evolución'),
        commandBar: fluent.CommandBar(
          mainAxisAlignment: fluent.MainAxisAlignment.end,
          primaryItems: [
            fluent.CommandBarButton(
              icon: const Icon(fluent.FluentIcons.add),
              label: const Text('Nueva Nota'),
              onPressed: () {
                setState(() => _isCreatingNote = true);
              },
            ),
          ],
        ),
      ),
      content: Consumer(
        builder: (context, ref, child) {
          final notesAsyncValue = ref.watch(
              evolutionNotesProvider(widget.patient.patientId!.toString()));

          return notesAsyncValue.when(
            loading: () => const fluent.Center(child: fluent.ProgressRing()),
            error: (err, stack) =>
                fluent.Center(child: Text('Error al cargar notas: $err')),
            data: (notes) {
              if (notes.isEmpty) {
                return const fluent.Center(
                    child: Text('Este paciente no tiene notas de evolución.'));
              }

              // --- CAMBIO AQUÍ: Se ajusta la tabla para mostrar la Cédula (ID) del Doctor ---
              return fluent.SizedBox(
                width:
                    double.infinity, // Asegura que la tabla ocupe todo el ancho
                child: fluent.Table(
                  columnWidths: const {
                    0: fluent.IntrinsicColumnWidth(), // ID
                    1: fluent.FlexColumnWidth(), // Fecha
                    2: fluent.FlexColumnWidth(), // Cédula
                    3: fluent.IntrinsicColumnWidth() //Botón
                  },
                  children: [
                    const fluent.TableRow(
                      children: [
                        fluent.TableCell(
                            child: fluent.Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('ID',
                                    style: TextStyle(
                                        fontWeight: fluent.FontWeight.bold)))),
                        fluent.TableCell(
                            child: fluent.Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Fecha y Hora',
                                    style: TextStyle(
                                        fontWeight: fluent.FontWeight.bold)))),
                        fluent.TableCell(
                            child: fluent.Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Doctor a cargo',
                                    style: TextStyle(
                                        fontWeight: fluent.FontWeight.bold)))),
                        fluent.TableCell(
                            child: fluent.Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Acciones',
                            style:
                                TextStyle(fontWeight: fluent.FontWeight.bold),
                          ),
                        ))
                      ],
                    ),
                    ...notes.map((note) => fluent.TableRow(
                          children: [
                            fluent.TableCell(
                                child: fluent.Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(note.documentId.toString()))),
                            fluent.TableCell(
                                child: fluent.Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_tableDateFormat
                                        .format(note.timestamp!)))),
                            // Mostramos el doctorId que sí tenemos
                            fluent.TableCell(
                                child: fluent.Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        note.doctor?.name ?? 'Desconocido'))),
                            fluent.TableCell(
                              verticalAlignment:
                                  fluent.TableCellVerticalAlignment.middle,
                              child: fluent.Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: fluent.FilledButton(
                                  child: const Text('Ver'),
                                  onPressed: () =>
                                      setState(() => _noteToShow = note),
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- Pestaña 3: Historia Clínica (Placeholder) ---
class _ClinicalHistoryTab extends ConsumerWidget {
  final PatientModel patient;
  const _ClinicalHistoryTab({required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos el provider para obtener la historia clínica
    final historyAsync =
        ref.watch(clinicalHistoryProvider(patient.patientId!.toString()));

    // El widget .when maneja los estados de carga, error y datos
    return historyAsync.when(
      loading: () => const fluent.Center(child: fluent.ProgressRing()),
      error: (err, stack) => fluent.Center(
        child: Text('Error al cargar la historia clínica: $err'),
      ),
      // Cuando tenemos datos (incluso si son nulos), mostramos el formulario
      data: (history) => ClinicalHistoryForm(
        patient: patient,
        history: history, // Pasamos la historia existente o null si no hay
      ),
    );
  }
}

// =========================================================================
// ===            VISTA DE DETALLES PARA ANDROID (SIN CAMBIOS)           ===
// =========================================================================
class _AndroidPatientDetails extends StatelessWidget {
  final PatientModel patient;
  const _AndroidPatientDetails({required this.patient});

  String formatDate(DateTime? date) {
    if (date == null) return 'No especificada';
    return DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es_MX').format(date);
  }

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
              subtitle: Text(
                  patient.phone?.trim().isEmpty == true || patient.phone == null
                      ? 'No especificado'
                      : patient.phone!)),
          material.ListTile(
              leading: const Icon(material.Icons.email_outlined),
              title: const Text('Correo electrónico'),
              subtitle: Text(
                  patient.email?.trim().isEmpty == true || patient.email == null
                      ? 'No especificado'
                      : patient.email!)),
          material.ListTile(
              leading: const Icon(material.Icons.cake_outlined),
              title: const Text('Fecha de nacimiento'),
              subtitle: Text(formatDate(patient.birthDate))),
          material.ListTile(
              leading: const Icon(material.Icons.person_outline),
              title: const Text('Género'),
              subtitle: Text(
                  patient.gender?.toString().split('.').last == 'MALE'
                      ? 'Masculino'
                      : 'Femenino')),
          material.ListTile(
              leading: const Icon(material.Icons.warning_amber_outlined),
              title: const Text('Alergias'),
              subtitle: Text(patient.allergies ?? 'Ninguna especificada')),
        ],
      ),
    );
  }
}
