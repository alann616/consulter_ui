// lib/features/patients/screens/evolution_note_screen.dart

import 'package:consulter_ui/core/models/evolution_note_model.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Formulario principal de la Nota de Evolución
class EvolutionNoteScreen extends ConsumerStatefulWidget {
  final PatientModel patient;

  const EvolutionNoteScreen({super.key, required this.patient});

  @override
  ConsumerState<EvolutionNoteScreen> createState() =>
      _EvolutionNoteScreenState();
}

class _EvolutionNoteScreenState extends ConsumerState<EvolutionNoteScreen> {
  int _tabIndex = 0;

  // Controladores para todos los campos de texto
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bodyTempController = TextEditingController();
  final _oxygenSaturationController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _systolicBPController = TextEditingController();
  final _diastolicBPController = TextEditingController();
  final _respiratoryRateController = TextEditingController();
  final _currentConditionController = TextEditingController();
  final _generalInspectionController = TextEditingController();
  final _laboratoryResultsController = TextEditingController();
  final _diagnosticImpressionController = TextEditingController();
  final _prognosisController = TextEditingController();
  final _treatmentPlanController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    // Liberamos todos los controladores
    _weightController.dispose();
    _heightController.dispose();
    // ... y así con todos los demás
    super.dispose();
  }

  void _saveNote() {
    // 1. Recolectar todos los datos de los controladores
    final noteData = EvolutionNoteModel(
      patientId: widget.patient.patientId,
      // doctorId se obtendrá del estado de autenticación
      weight: double.tryParse(_weightController.text),
      height: double.tryParse(_heightController.text),
      bodyTemp: double.tryParse(_bodyTempController.text),
      oxygenSaturation: int.tryParse(_oxygenSaturationController.text),
      heartRate: int.tryParse(_heartRateController.text),
      systolicBP: int.tryParse(_systolicBPController.text),
      diastolicBP: int.tryParse(_diastolicBPController.text),
      respiratoryRate: int.tryParse(_respiratoryRateController.text),
      currentCondition: _currentConditionController.text,
      generalInspection: _generalInspectionController.text,
      laboratoryResults: _laboratoryResultsController.text,
      diagnosticImpression: _diagnosticImpressionController.text,
      prognosis: _prognosisController.text,
      treatmentPlan: _treatmentPlanController.text,
      treatment: _treatmentController.text,
      instructions: _instructionsController.text,
      timestamp: DateTime.now(),
    );

    // 2. Llamar al provider para guardar la nota (esto se implementará después)
    // ref.read(documentNotifierProvider.notifier).createEvolutionNote(noteData);

    // 3. Mostrar confirmación y cerrar la pantalla
    fluent.displayInfoBar(context, builder: (context, close) {
      return fluent.InfoBar(
        title: const Text('Éxito'),
        content: const Text('Nota de evolución guardada correctamente.'),
        severity: fluent.InfoBarSeverity.success,
      );
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    final age = DateTime.now().year - (widget.patient.birthDate?.year ?? 0);
    final formattedDate = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es_MX')
        .format(DateTime.now());

    return fluent.NavigationView(
      appBar: fluent.NavigationAppBar(
        title: const Text('Nota de Evolución'),
        leading: fluent.IconButton(
          icon: const Icon(fluent.FluentIcons.back, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      content: fluent.ScaffoldPage(
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECCIÓN DE INFORMACIÓN DEL PACIENTE ---
              fluent.Card(
                child: fluent.Row(
                  mainAxisAlignment: fluent.MainAxisAlignment.spaceBetween,
                  children: [
                    fluent.InfoLabel(
                      label: 'Paciente',
                      child: Text(
                        '${widget.patient.name} ${widget.patient.lastName}',
                        style: theme.typography.bodyLarge,
                      ),
                    ),
                    fluent.InfoLabel(
                      label: 'Edad',
                      child:
                          Text('$age años', style: theme.typography.bodyLarge),
                    ),
                    fluent.InfoLabel(
                      label: 'Fecha',
                      child: Text(formattedDate,
                          style: theme.typography.bodyLarge),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SECCIÓN DE SIGNOS VITALES ---
              Text('Signos Vitales', style: theme.typography.subtitle),
              const SizedBox(height: 8),
              fluent.Card(
                child: fluent.Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _VitalSignInput(
                        label: 'Peso (kg)', controller: _weightController),
                    _VitalSignInput(
                        label: 'Talla (m)', controller: _heightController),
                    _VitalSignInput(
                        label: 'Temp (°C)', controller: _bodyTempController),
                    _VitalSignInput(
                        label: 'FR (x min)',
                        controller: _respiratoryRateController),
                    _VitalSignInput(
                        label: 'FC (x min)', controller: _heartRateController),
                    _VitalSignInput(
                        label: 'Sat O₂ (%)',
                        controller: _oxygenSaturationController),
                    _VitalSignInput(
                        label: 'TA Sistólica',
                        controller: _systolicBPController),
                    _VitalSignInput(
                        label: 'TA Diastólica',
                        controller: _diastolicBPController),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SECCIÓN CON PESTAÑAS ---
              fluent.TabView(
                currentIndex: _tabIndex,
                onChanged: (index) => setState(() => _tabIndex = index),
                tabs: [
                  fluent.Tab(
                    text: const Text('Exploración y Padecimiento'),
                    body: _buildExplorationTab(),
                  ),
                  fluent.Tab(
                    text: const Text('Diagnóstico y Plan'),
                    body: _buildDiagnosisTab(),
                  ),
                  fluent.Tab(
                    text: const Text('Tratamiento e Indicaciones'),
                    body: _buildTreatmentTab(),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- BOTÓN DE GUARDADO ---
              fluent.Row(
                mainAxisAlignment: fluent.MainAxisAlignment.end,
                children: [
                  fluent.FilledButton(
                    onPressed: _saveNote,
                    child: const Text('Finalizar y Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS INTERNOS PARA CADA PESTAÑA ---

  Widget _buildExplorationTab() {
    return fluent.Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fluent.InfoLabel(
            label: 'Padecimiento Actual',
            child: fluent.TextBox(
                maxLines: 5, controller: _currentConditionController),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Exploración Física',
            child: fluent.TextBox(
                maxLines: 5, controller: _generalInspectionController),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Resultados de Laboratorio y Gabinete',
            child: fluent.TextBox(
                maxLines: 5, controller: _laboratoryResultsController),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisTab() {
    return fluent.Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fluent.InfoLabel(
            label: 'Impresión Diagnóstica',
            child: fluent.TextBox(
                maxLines: 5, controller: _diagnosticImpressionController),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Pronóstico',
            child:
                fluent.TextBox(maxLines: 5, controller: _prognosisController),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Plan de Tratamiento',
            child: fluent.TextBox(
                maxLines: 5, controller: _treatmentPlanController),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentTab() {
    return fluent.Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fluent.InfoLabel(
            label: 'Tratamiento Farmacológico',
            child:
                fluent.TextBox(maxLines: 5, controller: _treatmentController),
          ),
          const SizedBox(height: 16),
          fluent.InfoLabel(
            label: 'Indicaciones y Próxima Cita',
            child: fluent.TextBox(
                maxLines: 5, controller: _instructionsController),
          ),
        ],
      ),
    );
  }
}

// Widget de ayuda para los campos de signos vitales
class _VitalSignInput extends fluent.StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _VitalSignInput({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: fluent.InfoLabel(
        label: label,
        child: fluent.TextBox(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ),
    );
  }
}
