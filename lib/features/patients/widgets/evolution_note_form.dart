// lib/features/patients/widgets/evolution_note_form.dart

import 'package:consulter_ui/core/models/evolution_note_model.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:consulter_ui/features/auth/providers/auth_provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EvolutionNoteForm extends ConsumerStatefulWidget {
  final PatientModel patient;
  final VoidCallback onFinish;

  final EvolutionNoteModel? note; // La nota a mostrar
  final bool isReadOnly; // Flag para modo solo lectura

  const EvolutionNoteForm({
    super.key,
    required this.patient,
    required this.onFinish,
    this.note, // Hacemos opcional la nota
    this.isReadOnly = false, // Por defecto, el formulario es para crear
  });

  @override
  ConsumerState<EvolutionNoteForm> createState() => _EvolutionNoteFormState();
}

class _EvolutionNoteFormState extends ConsumerState<EvolutionNoteForm> {
  int _tabIndex = 0;

  // Controladores
  // Controladores para todos los campos
  num? _weight;
  num? _height;
  num? _bodyTemp;
  int? _oxygenSaturation;
  int? _heartRate;
  int? _systolicBP;
  int? _diastolicBP;
  int? _respiratoryRate;

  final _currentConditionController = TextEditingController();
  final _generalInspectionController = TextEditingController();
  final _laboratoryResultsController = TextEditingController();
  final _diagnosticImpressionController = TextEditingController();
  final _prognosisController = TextEditingController();
  final _treatmentPlanController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // --- CAMBIO: Si hay una nota, llenamos el formulario con sus datos ---
    if (widget.note != null) {
      final n = widget.note!;
      _weight = n.weight;
      _height = n.height;
      _bodyTemp = n.bodyTemp;
      _oxygenSaturation = n.oxygenSaturation;
      _heartRate = n.heartRate;
      _systolicBP = n.systolicBP;
      _diastolicBP = n.diastolicBP;
      _respiratoryRate = n.respiratoryRate;
      _currentConditionController.text = n.currentCondition ?? '';
      _generalInspectionController.text = n.generalInspection ?? '';
      _laboratoryResultsController.text = n.laboratoryResults ?? '';
      _diagnosticImpressionController.text = n.diagnosticImpression ?? '';
      _prognosisController.text = n.prognosis ?? '';
      _treatmentPlanController.text = n.treatmentPlan ?? '';
      _treatmentController.text = n.treatment ?? '';
      _instructionsController.text = n.instructions ?? '';
    }
  }

  @override
  void dispose() {
    // Se eliminan los controllers de los campos de texto que quedan
    _currentConditionController.dispose();
    _generalInspectionController.dispose();
    _laboratoryResultsController.dispose();
    _diagnosticImpressionController.dispose();
    _prognosisController.dispose();
    _treatmentPlanController.dispose();
    _treatmentController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _saveNote() {
    // Asegúrate de que esta línea esté presente y correcta
    final doctorId =
        ref.read(authNotifierProvider).asData?.value?.doctorLicense;

    if (doctorId == null) {
      // Manejar el caso en que no haya un doctor logueado, tal vez mostrando un error.
      print("Error: No se pudo obtener la licencia del doctor.");
      return;
    }

    final noteData = EvolutionNoteModel(
      patientId: widget.patient.patientId,
      doctorId: doctorId,
      weight: _weight?.toDouble(),
      height: _height?.toDouble(),
      bodyTemp: _bodyTemp?.toDouble(),
      oxygenSaturation: _oxygenSaturation,
      heartRate: _heartRate,
      systolicBP: _systolicBP,
      diastolicBP: _diastolicBP,
      respiratoryRate: _respiratoryRate,
      currentCondition: _currentConditionController.text,
      generalInspection: _generalInspectionController.text,
      laboratoryResults: _laboratoryResultsController.text,
      diagnosticImpression: _diagnosticImpressionController.text,
      prognosis: _prognosisController.text,
      treatmentPlan: _treatmentPlanController.text,
      treatment: _treatmentController.text,
      instructions: _instructionsController.text,
      // documentType se asigna por defecto en el modelo
    );

    ref
        .read(patientNotifierProvider.notifier)
        .createEvolutionNote(noteData)
        .then((_) {
      if (mounted && !ref.read(patientNotifierProvider).hasError) {
        widget.onFinish(); // Volvemos a la lista de notas
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    final age = DateTime.now().year - (widget.patient.birthDate!.year);
    final ageInMonths =
        DateTime.now().month - (widget.patient.birthDate!.month ?? 0);
    final noteTimeStamp = widget.note?.timestamp ?? DateTime.now();
    final formattedDate = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es_MX')
        .format(DateTime.now());
    final formattedTime = DateFormat('HH:mm', 'es_MX').format(noteTimeStamp);
    final List<Widget> vitalSignsWidgets = [
      _VitalSignInput(
        label: 'Peso (kg)',
        value: _weight,
        onChanged: (value) => setState(() => _weight = value),
      ),
      _VitalSignInput(
        label: 'Talla (m)',
        value: _height,
        onChanged: (value) => setState(() => _height = value),
      ),
      _VitalSignInput(
        label: 'Temp (°C)',
        value: _bodyTemp,
        onChanged: (value) => setState(() => _bodyTemp = value),
      ),
      _VitalSignInput(
        label: 'FR (x min)',
        value: _respiratoryRate,
        onChanged: (value) => setState(() => _respiratoryRate = value?.toInt()),
      ),
      _VitalSignInput(
        label: 'FC (x min)',
        value: _heartRate,
        onChanged: (value) => setState(() => _heartRate = value?.toInt()),
      ),
      _VitalSignInput(
        label: 'Sat O₂ (%)',
        value: _oxygenSaturation,
        onChanged: (value) =>
            setState(() => _oxygenSaturation = value?.toInt()),
      ),
      _VitalSignInput(
        label: 'TA Sistólica',
        value: _systolicBP,
        onChanged: (value) => setState(() => _systolicBP = value?.toInt()),
      ),
      _VitalSignInput(
        label: 'TA Diastólica',
        value: _diastolicBP,
        onChanged: (value) => setState(() => _diastolicBP = value?.toInt()),
      ),
    ];
    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: Text(widget.isReadOnly
            ? "Detalles de la Nota"
            : "Creando Nueva Nota de Evolución"),
        commandBar: fluent.CommandBar(
          mainAxisAlignment: fluent.MainAxisAlignment.end,
          primaryItems: widget.isReadOnly
              ? [
                  fluent.CommandBarButton(
                    icon: const Icon(fluent.FluentIcons.back),
                    label: const Text('Cerrar'),
                    onPressed: widget.onFinish,
                  ),
                ]
              : [
                  fluent.CommandBarButton(
                    icon: const Icon(fluent.FluentIcons.cancel),
                    label: const Text('Cancelar'),
                    onPressed: widget.onFinish,
                  ),
                  fluent.CommandBarButton(
                    icon: const Icon(fluent.FluentIcons.save),
                    label: const Text('Guardar Nota'),
                    onPressed: _saveNote,
                  ),
                ],
        ),
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fluent.Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Paciente: ${widget.patient.name} ${widget.patient.lastName} ${widget.patient.secondLastName}',
                        style: theme.typography.subtitle),
                    Text(
                        'Edad: ${(age <= 0 && ageInMonths <= 1) ? '$ageInMonths mes' : (age <= 0) ? '$ageInMonths meses' : (age == 1) ? '$age año' : '$age años'}',
                        style: theme.typography.subtitle),
                    Text('Fecha: $formattedDate',
                        style: theme.typography.subtitle),
                    Text('Hora: $formattedTime')
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Signos Vitales', style: theme.typography.subtitle),
            const SizedBox(height: 8),
            fluent.Card(
              padding: const fluent.EdgeInsets.all(12),
              child: fluent.GridView.builder(
                shrinkWrap: true,
                physics: const fluent.NeverScrollableScrollPhysics(),
                gridDelegate:
                    const fluent.SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 1,
                ),
                itemCount: vitalSignsWidgets.length,
                itemBuilder: (context, index) {
                  // Se deshabilita el onChanged si es solo lectura
                  final onChanged = widget.isReadOnly
                      ? null
                      : (num? value) {
                          setState(() {
                            switch (index) {
                              case 0:
                                _weight = value;
                                break;
                              case 1:
                                _height = value;
                                break;
                              case 2:
                                _bodyTemp = value;
                                break;
                              case 3:
                                _respiratoryRate = value?.toInt();
                                break;
                              case 4:
                                _heartRate = value?.toInt();
                                break;
                              case 5:
                                _oxygenSaturation = value?.toInt();
                                break;
                              case 6:
                                _systolicBP = value?.toInt();
                                break;
                              case 7:
                                _diastolicBP = value?.toInt();
                                break;
                            }
                          });
                        };

                  // Se obtienen los valores y etiquetas
                  final labels = [
                    'Peso (kg)',
                    'Talla (m)',
                    'Temp (°C)',
                    'FR (x min)',
                    'FC (x min)',
                    'Sat O₂ (%)',
                    'TA Sistólica',
                    'TA Diastólica'
                  ];
                  final values = [
                    _weight,
                    _height,
                    _bodyTemp,
                    _respiratoryRate,
                    _heartRate,
                    _oxygenSaturation,
                    _systolicBP,
                    _diastolicBP
                  ];

                  return _VitalSignInput(
                    label: labels[index],
                    value: values[index],
                    onChanged: onChanged,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 450, // Aumentamos la altura para los nuevos campos
              child: fluent.TabView(
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
            ),
          ],
        ),
      ),
    );
  }

  // Move the following methods inside the _EvolutionNoteFormState class
  Widget _buildExplorationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fluent.InfoLabel(
              label: 'Padecimiento Actual',
              child: fluent.TextBox(
                  maxLines: null, controller: _currentConditionController)),
          const SizedBox(height: 12),
          fluent.InfoLabel(
              label: 'Exploración Física (Inspección General)',
              child: fluent.TextBox(
                  maxLines: null, controller: _generalInspectionController)),
          const SizedBox(height: 12),
          fluent.InfoLabel(
              label: 'Resultados de Laboratorio y Gabinete',
              child: fluent.TextBox(
                  maxLines: null, controller: _laboratoryResultsController)),
        ],
      ),
    );
  }

  Widget _buildDiagnosisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fluent.InfoLabel(
              label: 'Impresión Diagnóstica',
              child: fluent.TextBox(
                  maxLines: 5, controller: _diagnosticImpressionController)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Plan de Tratamiento',
              child: fluent.TextBox(
                  maxLines: 5, controller: _treatmentPlanController)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Pronóstico',
              child: fluent.TextBox(
                  maxLines: 5, controller: _prognosisController)),
        ],
      ),
    );
  }

  Widget _buildTreatmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fluent.InfoLabel(
              label: 'Tratamiento Farmacológico',
              child: fluent.TextBox(
                  maxLines: 8, controller: _treatmentController)),
          const SizedBox(height: 16),
          fluent.InfoLabel(
              label: 'Indicaciones y Próxima Cita',
              child: fluent.TextBox(
                  maxLines: 8, controller: _instructionsController)),
        ],
      ),
    );
  }
}

class _VitalSignInput extends fluent.StatelessWidget {
  final String label;
  final num? value;
  final void Function(num?)? onChanged;

  const _VitalSignInput({
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return fluent.InfoLabel(
      label: label,
      child: fluent.NumberBox<num>(
        value: value,
        onChanged: onChanged, // Se pasa el callback (puede ser null)
        mode: fluent.SpinButtonPlacementMode.inline,
      ),
    );
  }
}
