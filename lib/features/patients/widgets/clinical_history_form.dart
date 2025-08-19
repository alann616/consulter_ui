// lib/features/patients/widgets/clinical_history_form.dart

import 'dart:typed_data'; // Importación necesaria para Uint8List
import 'package:consulter_ui/core/models/clinical_history_model.dart';
import 'package:consulter_ui/core/models/enums.dart';
import 'package:consulter_ui/core/models/gynecological_model.dart';
import 'package:consulter_ui/core/models/hereditary_model.dart';
import 'package:consulter_ui/core/models/non_pathological_model.dart';
import 'package:consulter_ui/core/models/pathological_model.dart';
import 'package:consulter_ui/core/models/patient_interview_model.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/auth/providers/auth_provider.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:consulter_ui/core/services/pdf_service.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Paquetes para las opciones de exportación
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:file_saver/file_saver.dart';

class ClinicalHistoryForm extends ConsumerStatefulWidget {
  final PatientModel patient;
  final ClinicalHistoryModel? history;

  const ClinicalHistoryForm({
    super.key,
    required this.patient,
    this.history,
  });

  @override
  ConsumerState<ClinicalHistoryForm> createState() =>
      _ClinicalHistoryFormState();
}

class _ClinicalHistoryFormState extends ConsumerState<ClinicalHistoryForm> {
  // --- Controladores y Estado para la UI ---
  final Map<String, TextEditingController> _controllers = {};

  final _currentConditionController = TextEditingController();
  final _diagnosticImpressionController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _prognosisController = TextEditingController();

  num? _weight,
      _height,
      _bodyTemp,
      _oxygenSaturation,
      _heartRate,
      _systolicBP,
      _diastolicBP,
      _respiratoryRate,
      _bodyMassIndex,
      _capillaryGlycemia,
      _cephalicPerimeter,
      _abdominalPerimeter;

  String? _maritalStatus;
  String? _floorMaterial;
  final Set<String> _wallMaterials = {};
  final Set<String> _services = {};
  bool _isFullyVaccinated = false;
  final Set<String> _substanceUses = {};
  String? _menstrualCycleRegularity;
  num? _menarcheAge,
      _sexualActivityStartAge,
      _numberOfPregnancies,
      _numberOfBirths,
      _numberOfAbortions,
      _numberOfCesareanSections,
      _macrosomicChildren,
      _lowBirthWeightChildren;
  DateTime? _lastMenstrualPeriod, _lastDeliveryDate, _lastPapSmearDate;

  bool _hasChanges = false;
  late Map<String, dynamic> _initialState;
  final fluent.FlyoutController _flyoutController = fluent.FlyoutController();

  @override
  void initState() {
    super.initState();
    _initializeFormState();
    _initialState = _getCurrentStateAsMap();
    _addListeners();
  }

  @override
  void dispose() {
    _removeListeners();
    _controllers.forEach((_, controller) => controller.dispose());
    _currentConditionController.dispose();
    _diagnosticImpressionController.dispose();
    _treatmentController.dispose();
    _prognosisController.dispose();
    _flyoutController.dispose();
    super.dispose();
  }

  void _initializeFormState() {
    final h = widget.history;

    if (h != null) {
      _currentConditionController.text = h.currentCondition ?? '';
      _diagnosticImpressionController.text = h.diagnosticImpression ?? '';
      _treatmentController.text = h.treatment ?? '';
      _prognosisController.text = h.prognosis ?? '';

      _weight = h.weight;
      _height = h.height;
      _bodyTemp = h.bodyTemp;
      _oxygenSaturation = h.oxygenSaturation;
      _heartRate = h.heartRate;
      _systolicBP = h.systolicBP;
      _diastolicBP = h.diastolicBP;
      _respiratoryRate = h.respiratoryRate;
      _bodyMassIndex = h.bodyMassIndex;
      _capillaryGlycemia = h.capillaryGlycemia;
      _cephalicPerimeter = h.cephalicPerimeter;
      _abdominalPerimeter = h.abdominalPerimeter;
    } else {
      _prognosisController.text = 'RESERVADO A EVOLUCIÓN';
    }

    _initController('diabetesMellitus', h?.hereditary?.diabetesMellitus);
    _initController('hypertensionHereditary', h?.hereditary?.hypertension);
    _initController('tuberculosis', h?.hereditary?.tuberculosis);
    _initController('neoplasms', h?.hereditary?.neoplasms);
    _initController('heartConditions', h?.hereditary?.heartConditions);
    _initController('congenitalAnomalies', h?.hereditary?.congenitalAnomalies);
    _initController('endocrineDisorders', h?.hereditary?.endocrineDisorders);
    _initController(
        'otherHereditaryConditions', h?.hereditary?.otherHereditaryConditions);
    _initController('surgicalHistory', h?.pathological?.surgicalHistory);
    _initController('traumaticHistory', h?.pathological?.traumaticHistory);
    _initController('allergicHistory', h?.pathological?.allergicHistory);
    _initController('transfusionHistory', h?.pathological?.transfusionHistory);
    _initController('coombsTest', h?.pathological?.coombsTest);
    _initController('hypertensionPathological', h?.pathological?.hypertension);
    _initController('diabetes', h?.pathological?.diabetes);
    _initController('otherPathologicalConditions',
        h?.pathological?.otherPathologicalConditions);
    _initController('reviewOfSystems', h?.patientInterview?.reviewOfSystems);
    _initController('generalSimptoms', h?.patientInterview?.generalSimptoms);
    _initController('head', h?.patientInterview?.head);
    _initController('neck', h?.patientInterview?.neck);
    _initController('thorax', h?.patientInterview?.thorax);
    _initController('abdomen', h?.patientInterview?.abdomen);
    _initController('backbone', h?.patientInterview?.backbone);
    _initController(
        'externalGenitalia', h?.patientInterview?.externalGenitalia);
    _initController('rectalTouch', h?.patientInterview?.rectalTouch);
    _initController('vaginalTouch', h?.patientInterview?.vaginalTouch);
    _initController('limbs', h?.patientInterview?.limbs);

    final np = h?.nonPathological;
    if (np != null) {
      _maritalStatus = np.maritalStatus;
      _floorMaterial = np.floorMaterial;
      _isFullyVaccinated = np.isFullyVaccinated ?? false;
      _wallMaterials.addAll(
          np.wallMaterial?.split(', ').where((s) => s.isNotEmpty) ?? []);
      _services
          .addAll(np.services?.split(', ').where((s) => s.isNotEmpty) ?? []);
      _substanceUses.addAll(
          np.substanceUse?.split(', ').where((s) => s.isNotEmpty) ?? []);
      _initController('religion', np.religion);
      _initController('occupation', np.occupation);
    } else {
      _initController('religion', '');
      _initController('occupation', '');
    }

    final g = h?.gynecological;
    if (widget.patient.gender == Gender.FEMALE && g != null) {
      _menarcheAge = g.menarcheAge;
      _menstrualCycleRegularity = g.menstrualCycleRegularity;
      _sexualActivityStartAge = g.sexualActivityStartAge;
      _numberOfPregnancies = g.numberOfPregnancies;
      _numberOfBirths = g.numberOfBirths;
      _numberOfAbortions = g.numberOfAbortions;
      _numberOfCesareanSections = g.numberOfCesareanSections;
      _macrosomicChildren = g.macrosomicChildren;
      _lowBirthWeightChildren = g.lowBirthWeightChildren;
      _initController('uterineCurettage', g.uterineCurettage);
      _initController('familyPlanningMethod', g.familyPlanningMethod);
      _initController(
          'contraceptiveUsageDuration', g.contraceptiveUsageDuration);
      _lastMenstrualPeriod = g.lastMenstrualPeriod;
      _lastDeliveryDate = g.lastDeliveryDate;
      _lastPapSmearDate = g.lastPapSmearDate;
    } else if (widget.patient.gender == Gender.FEMALE) {
      _initController('uterineCurettage', '');
      _initController('familyPlanningMethod', '');
      _initController('contraceptiveUsageDuration', '');
    }
  }

  void _initController(String key, String? value) {
    _controllers[key] = TextEditingController(text: value ?? '');
  }

  void _addListeners() {
    _controllers.values.forEach((c) => c.addListener(_checkForChanges));
    _currentConditionController.addListener(_checkForChanges);
    _diagnosticImpressionController.addListener(_checkForChanges);
    _treatmentController.addListener(_checkForChanges);
    _prognosisController.addListener(_checkForChanges);
  }

  void _removeListeners() {
    _controllers.values.forEach((c) => c.removeListener(_checkForChanges));
    _currentConditionController.removeListener(_checkForChanges);
    _diagnosticImpressionController.removeListener(_checkForChanges);
    _treatmentController.removeListener(_checkForChanges);
    _prognosisController.removeListener(_checkForChanges);
  }

  Map<String, dynamic> _getCurrentStateAsMap() {
    final map = <String, dynamic>{};
    _controllers.forEach((key, value) {
      map[key] = value.text;
    });

    map['currentCondition'] = _currentConditionController.text;
    map['diagnosticImpression'] = _diagnosticImpressionController.text;
    map['treatment'] = _treatmentController.text;
    map['prognosis'] = _prognosisController.text;
    map['weight'] = _weight;
    map['height'] = _height;
    map['bodyTemp'] = _bodyTemp;
    map['oxygenSaturation'] = _oxygenSaturation;
    map['heartRate'] = _heartRate;
    map['systolicBP'] = _systolicBP;
    map['diastolicBP'] = _diastolicBP;
    map['respiratoryRate'] = _respiratoryRate;
    map['bodyMassIndex'] = _bodyMassIndex;
    map['capillaryGlycemia'] = _capillaryGlycemia;
    map['cephalicPerimeter'] = _cephalicPerimeter;
    map['abdominalPerimeter'] = _abdominalPerimeter;

    map['maritalStatus'] = _maritalStatus;
    map['floorMaterial'] = _floorMaterial;
    map['wallMaterials'] = _wallMaterials.join(', ');
    map['services'] = _services.join(', ');
    map['isFullyVaccinated'] = _isFullyVaccinated;
    map['substanceUses'] = _substanceUses.join(', ');
    map['menstrualCycleRegularity'] = _menstrualCycleRegularity;
    map['menarcheAge'] = _menarcheAge;
    map['sexualActivityStartAge'] = _sexualActivityStartAge;
    map['numberOfPregnancies'] = _numberOfPregnancies;
    map['numberOfBirths'] = _numberOfBirths;
    map['numberOfAbortions'] = _numberOfAbortions;
    map['numberOfCesareanSections'] = _numberOfCesareanSections;
    map['macrosomicChildren'] = _macrosomicChildren;
    map['lowBirthWeightChildren'] = _lowBirthWeightChildren;
    map['lastMenstrualPeriod'] = _lastMenstrualPeriod;
    map['lastDeliveryDate'] = _lastDeliveryDate;
    map['lastPapSmearDate'] = _lastPapSmearDate;
    return map;
  }

  void _checkForChanges() {
    final currentState = _getCurrentStateAsMap();
    bool changed = false;
    if (_initialState.length != currentState.length) {
      changed = true;
    } else {
      for (final key in _initialState.keys) {
        if (_initialState[key] != currentState[key]) {
          changed = true;
          break;
        }
      }
    }

    if (changed != _hasChanges) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  // --- NUEVA FUNCIÓN PARA CALCULAR IMC ---
  void _calculateIMC() {
    final weight = _weight;
    final height = _height;

    if (weight != null && weight > 0 && height != null && height > 0) {
      setState(() {
        _bodyMassIndex = weight / (height * height);
      });
    } else {
      setState(() {
        _bodyMassIndex = null;
      });
    }
    // Llama a _checkForChanges para actualizar el estado del botón Guardar
    _checkForChanges();
  }

  void _saveHistory() {
    final doctorId =
        ref.read(authNotifierProvider).asData?.value?.doctorLicense;
    if (doctorId == null) {
      print("ERROR CRÍTICO: No se pudo obtener la licencia del doctor.");
      return;
    }
    final historyData = ClinicalHistoryModel(
      documentId: widget.history?.documentId,
      documentType: DocumentType.CLINICAL_HISTORY,
      patientId: widget.patient.patientId,
      doctorLicense: doctorId,
      currentCondition: _currentConditionController.text,
      diagnosticImpression: _diagnosticImpressionController.text,
      treatment: _treatmentController.text,
      prognosis: _prognosisController.text,
      weight: _weight?.toDouble(),
      height: _height?.toDouble(),
      bodyTemp: _bodyTemp?.toDouble(),
      oxygenSaturation: _oxygenSaturation?.toInt(),
      heartRate: _heartRate?.toInt(),
      systolicBP: _systolicBP?.toInt(),
      diastolicBP: _diastolicBP?.toInt(),
      respiratoryRate: _respiratoryRate?.toInt(),
      bodyMassIndex: _bodyMassIndex?.toDouble(),
      capillaryGlycemia: _capillaryGlycemia?.toDouble(),
      cephalicPerimeter: _cephalicPerimeter?.toDouble(),
      abdominalPerimeter: _abdominalPerimeter?.toDouble(),
      hereditary: HereditaryModel(
        diabetesMellitus: _controllers['diabetesMellitus']!.text,
        hypertension: _controllers['hypertensionHereditary']!.text,
        tuberculosis: _controllers['tuberculosis']!.text,
        neoplasms: _controllers['neoplasms']!.text,
        heartConditions: _controllers['heartConditions']!.text,
        congenitalAnomalies: _controllers['congenitalAnomalies']!.text,
        endocrineDisorders: _controllers['endocrineDisorders']!.text,
        otherHereditaryConditions:
            _controllers['otherHereditaryConditions']!.text,
      ),
      pathological: PathologicalModel(
        surgicalHistory: _controllers['surgicalHistory']!.text,
        traumaticHistory: _controllers['traumaticHistory']!.text,
        allergicHistory: _controllers['allergicHistory']!.text,
        transfusionHistory: _controllers['transfusionHistory']!.text,
        coombsTest: _controllers['coombsTest']!.text,
        hypertension: _controllers['hypertensionPathological']!.text,
        diabetes: _controllers['diabetes']!.text,
        otherPathologicalConditions:
            _controllers['otherPathologicalConditions']!.text,
      ),
      patientInterview: PatientInterviewModel(
        reviewOfSystems: _controllers['reviewOfSystems']!.text,
        generalSimptoms: _controllers['generalSimptoms']!.text,
        head: _controllers['head']!.text,
        neck: _controllers['neck']!.text,
        thorax: _controllers['thorax']!.text,
        abdomen: _controllers['abdomen']!.text,
        backbone: _controllers['backbone']!.text,
        externalGenitalia: _controllers['externalGenitalia']!.text,
        rectalTouch: _controllers['rectalTouch']!.text,
        vaginalTouch: _controllers['vaginalTouch']!.text,
        limbs: _controllers['limbs']!.text,
      ),
      nonPathological: NonPathologicalModel(
        maritalStatus: _maritalStatus,
        religion: _controllers['religion']!.text,
        occupation: _controllers['occupation']!.text,
        floorMaterial: _floorMaterial,
        wallMaterial: _wallMaterials.join(', '),
        services: _services.join(', '),
        substanceUse: _substanceUses.join(', '),
        isFullyVaccinated: _isFullyVaccinated,
        overcrowding: widget.history?.nonPathological?.overcrowding,
        promiscuity: widget.history?.nonPathological?.promiscuity,
        isSmoker: widget.history?.nonPathological?.isSmoker,
        isDrinker: widget.history?.nonPathological?.isDrinker,
      ),
      gynecological: widget.patient.gender == Gender.FEMALE
          ? GynecologicalModel(
              menarcheAge: _menarcheAge?.toInt(),
              menstrualCycleRegularity: _menstrualCycleRegularity,
              sexualActivityStartAge: _sexualActivityStartAge?.toInt(),
              numberOfPregnancies: _numberOfPregnancies?.toInt(),
              numberOfBirths: _numberOfBirths?.toInt(),
              numberOfAbortions: _numberOfAbortions?.toInt(),
              numberOfCesareanSections: _numberOfCesareanSections?.toInt(),
              macrosomicChildren: _macrosomicChildren?.toInt(),
              lowBirthWeightChildren: _lowBirthWeightChildren?.toInt(),
              uterineCurettage: _controllers['uterineCurettage']!.text,
              familyPlanningMethod: _controllers['familyPlanningMethod']!.text,
              contraceptiveUsageDuration:
                  _controllers['contraceptiveUsageDuration']!.text,
              lastMenstrualPeriod: _lastMenstrualPeriod,
              lastDeliveryDate: _lastDeliveryDate,
              lastPapSmearDate: _lastPapSmearDate,
            )
          : null,
    );

    ref.read(patientNotifierProvider.notifier).saveClinicalHistory(historyData);

    setState(() {
      _hasChanges = false;
      _initialState = _getCurrentStateAsMap();
    });
  }

  // --- LÓGICA DE EXPORTACIÓN ---

  Future<void> _exportAction(Function(Uint8List, String) onPdfGenerated) async {
    if (widget.history == null) {
      fluent.displayInfoBar(context,
          builder: (ctx, close) => const fluent.InfoBar(
                title: Text('Acción requerida'),
                content: Text(
                    'Primero debe guardar la historia clínica para poder exportarla.'),
                severity: fluent.InfoBarSeverity.warning,
                isLong: true,
              ));
      return;
    }

    fluent.showDialog(
        context: context,
        builder: (ctx) => const fluent.ContentDialog(
              title: Text('Generando documento...'),
              content: fluent.Center(child: fluent.ProgressRing()),
            ));

    try {
      final pdfBytes = await PdfService.generateClinicalHistoryPdf(
          widget.patient, widget.history!);
      final fileName = '${widget.history?.documentName}.pdf';

      Navigator.of(context).pop();

      await onPdfGenerated(pdfBytes, fileName);
    } catch (e) {
      Navigator.of(context).pop();
      fluent.displayInfoBar(context,
          builder: (ctx, close) => fluent.InfoBar(
                title: const Text('Error'),
                content: Text('No se pudo generar el PDF: $e'),
                severity: fluent.InfoBarSeverity.error,
                isLong: true,
              ));
    }
  }

  Future<void> _showPrintDialog() async {
    await _exportAction((pdfBytes, fileName) async {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: fileName,
      );
    });
  }

  Future<void> _savePdfDirectly() async {
    await _exportAction((pdfBytes, fileName) async {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: pdfBytes,
        mimeType: MimeType.pdf,
      );
      fluent.displayInfoBar(context,
          builder: (ctx, close) => fluent.InfoBar(
                title: const Text('Éxito'),
                content:
                    Text('PDF guardado como "$fileName" en tus descargas.'),
                severity: fluent.InfoBarSeverity.success,
                isLong: true,
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    final isFemale = widget.patient.gender == Gender.FEMALE;

    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: const Text('Historia Clínica'),
        commandBar: fluent.CommandBar(
          mainAxisAlignment: fluent.MainAxisAlignment.end,
          primaryItems: [
            fluent.CommandBarButton(
              icon: const Icon(fluent.FluentIcons.export),
              label: const Text('Exportar'),
              onPressed: () {
                _flyoutController.showFlyout(
                  builder: (context) {
                    return fluent.MenuFlyout(
                      items: [
                        fluent.MenuFlyoutItem(
                          leading: const Icon(fluent.FluentIcons.print),
                          text: const Text('Imprimir...'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showPrintDialog();
                          },
                        ),
                        fluent.MenuFlyoutItem(
                          leading: const Icon(fluent.FluentIcons.save),
                          text: const Text('Guardar como PDF'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _savePdfDirectly();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            fluent.CommandBarButton(
              icon: const Icon(fluent.FluentIcons.save),
              label: const Text('Guardar Cambios'),
              onPressed: _hasChanges ? _saveHistory : null,
            ),
          ],
        ),
      ),
      content: fluent.FlyoutTarget(
        controller: _flyoutController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVitalsAndConditionSection(theme),
              const SizedBox(height: 16),
              _buildHereditarySection(theme),
              const SizedBox(height: 16),
              _buildNonPathologicalSection(theme),
              const SizedBox(height: 16),
              _buildPathologicalSection(theme),
              const SizedBox(height: 16),
              if (isFemale) ...[
                _buildGynecologicalSection(theme),
                const SizedBox(height: 16),
              ],
              _buildPatientInterviewSection(theme),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCCIÓN DE SECCIONES Y CONTROLES ---
// En lib/features/patients/widgets/clinical_history_form.dart

  Widget _buildVitalsAndConditionSection(fluent.FluentThemeData theme) {
    return fluent.Expander(
      initiallyExpanded: true,
      header: Text('PADECIMIENTO ACTUAL Y EXPLORACIÓN FÍSICA',
          style: theme.typography.subtitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLargeTextField(
              'PADECIMIENTO ACTUAL', _currentConditionController),
          const SizedBox(height: 16),
          fluent.Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLargeTextField('IMPRESIÓN DIAGNÓSTICA',
                        _diagnosticImpressionController),
                    const SizedBox(height: 12),
                    _buildLargeTextField('TRATAMIENTO', _treatmentController),
                    const SizedBox(height: 12),
                    _buildLargeTextField('PRONÓSTICO', _prognosisController),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: fluent.InfoLabel(
                  label: 'SIGNOS VITALES Y ANTROPOMETRÍA',
                  child: Column(
                    // Se cambia Wrap por Column
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- Fila 1 ---
                      fluent.Row(
                        children: [
                          Expanded(
                              child:
                                  _buildNumberBox('Peso (kg)', _weight, (val) {
                            setState(() {
                              _weight = val;
                            });
                            _calculateIMC();
                          }, step: 5)),
                          const SizedBox(width: 12),
                          Expanded(
                              child:
                                  _buildNumberBox('Talla (m)', _height, (val) {
                            setState(() {
                              _height = val;
                            });
                            _calculateIMC();
                          }, step: 0.01)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // --- Fila 2 ---
                      fluent.Row(
                        children: [
                          Expanded(
                              child: _buildNumberBox(
                                  'IMC', _bodyMassIndex, (val) {},
                                  enabled: false)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildNumberBox(
                                  'Temp (°C)',
                                  _bodyTemp,
                                  (val) => setState(() {
                                        _bodyTemp = val;
                                        _checkForChanges();
                                      }),
                                  step: 0.1,
                                  defaultValue: 36)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // --- Fila 3 ---
                      fluent.Row(
                        children: [
                          Expanded(
                              child: _buildNumberBox(
                                  'FC (x\')',
                                  _heartRate,
                                  (val) => setState(() {
                                        _heartRate = val;
                                        _checkForChanges();
                                      }))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildNumberBox(
                                  'FR (x\')',
                                  _respiratoryRate,
                                  (val) => setState(() {
                                        _respiratoryRate = val;
                                        _checkForChanges();
                                      }))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // --- Fila 4 ---
                      fluent.Row(
                        children: [
                          Expanded(
                              child: _buildNumberBox(
                                  'TA Sistólica',
                                  _systolicBP,
                                  (val) => setState(() {
                                        _systolicBP = val;
                                        _checkForChanges();
                                      }),
                                  defaultValue: 120,
                                  step: 5)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildNumberBox(
                                  'TA Diastólica',
                                  _diastolicBP,
                                  (val) => setState(() {
                                        _diastolicBP = val;
                                        _checkForChanges();
                                      }),
                                  defaultValue: 80,
                                  step: 5)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // --- Fila 5 ---
                      fluent.Row(
                        children: [
                          Expanded(
                              child: _buildNumberBox(
                                  'SpO2 (%)',
                                  _oxygenSaturation,
                                  (val) => setState(() {
                                        _oxygenSaturation = val;
                                        _checkForChanges();
                                      }))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildNumberBox(
                                  'Glucemia (mg/dL)',
                                  _capillaryGlycemia,
                                  (val) => setState(() {
                                        _capillaryGlycemia = val;
                                        _checkForChanges();
                                      }))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // --- Fila 6 ---
                      fluent.Row(
                        children: [
                          Expanded(
                              child: _buildNumberBox(
                                  'Per. Cefálico (cm)',
                                  _cephalicPerimeter,
                                  (val) => setState(() {
                                        _cephalicPerimeter = val;
                                        _checkForChanges();
                                      }))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildNumberBox(
                                  'Per. Abdominal (cm)',
                                  _abdominalPerimeter,
                                  (val) => setState(() {
                                        _abdominalPerimeter = val;
                                        _checkForChanges();
                                      }))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHereditarySection(fluent.FluentThemeData theme) {
    return fluent.Expander(
      initiallyExpanded: true,
      header: Text('ANTECEDENTES HEREDITARIOS Y FAMILIARES',
          style: theme.typography.subtitle),
      content: Column(
        children: [
          _buildTextField(
              'Diabetes Mellitus', _controllers['diabetesMellitus']!),
          _buildTextField(
              'Hipertensión', _controllers['hypertensionHereditary']!),
          _buildTextField('Tuberculosis', _controllers['tuberculosis']!),
          _buildTextField('Neoplasias', _controllers['neoplasms']!),
          _buildTextField('Cardiopatías', _controllers['heartConditions']!),
          _buildTextField(
              'Anomalías Congénitas', _controllers['congenitalAnomalies']!),
          _buildTextField(
              'Trastornos Endocrinos', _controllers['endocrineDisorders']!),
          _buildTextField('Otros Padecimientos Hereditarios',
              _controllers['otherHereditaryConditions']!),
        ],
      ),
    );
  }

  Widget _buildNonPathologicalSection(fluent.FluentThemeData theme) {
    return fluent.Expander(
      initiallyExpanded: true,
      header: Text('ANTECEDENTES PERSONALES NO PATOLÓGICOS',
          style: theme.typography.subtitle),
      content: fluent.Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRadioGroup(
                  label: 'ESTADO CIVIL',
                  items: ['Soltero', 'Casado', 'Unión libre', 'Hacimiento'],
                  groupValue: _maritalStatus,
                  onChanged: (val) => setState(() {
                    _maritalStatus = val;
                    _checkForChanges();
                  }),
                ),
                const SizedBox(height: 12),
                _buildTextField('RELIGIÓN', _controllers['religion']!),
                const SizedBox(height: 12),
                _buildTextField('OCUPACIÓN', _controllers['occupation']!),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRadioGroup(
                  label: 'PISO',
                  items: ['Tierra', 'Cemento'],
                  groupValue: _floorMaterial,
                  onChanged: (val) => setState(() {
                    _floorMaterial = val;
                    _checkForChanges();
                  }),
                ),
                const SizedBox(height: 12),
                _buildCheckboxGroup(
                  label: 'PAREDES',
                  items: ['Block', 'Adobe', 'Madera', 'Otros'],
                  selectedValues: _wallMaterials,
                  onChanged: (item, val) => setState(() {
                    if (val ?? false)
                      _wallMaterials.add(item);
                    else
                      _wallMaterials.remove(item);
                    _checkForChanges();
                  }),
                ),
                const SizedBox(height: 12),
                _buildCheckboxGroup(
                  label: 'SERVICIOS',
                  items: ['Agua', 'Drenaje', 'Gas', 'Leña'],
                  selectedValues: _services,
                  onChanged: (item, val) => setState(() {
                    if (val ?? false)
                      _services.add(item);
                    else
                      _services.remove(item);
                    _checkForChanges();
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fluent.InfoLabel(
                  label: 'ESQUEMA DE VACUNACIÓN',
                  child: fluent.ToggleSwitch(
                    checked: _isFullyVaccinated,
                    onChanged: (val) => setState(() {
                      _isFullyVaccinated = val;
                      _checkForChanges();
                    }),
                    content:
                        Text(_isFullyVaccinated ? 'Completa' : 'Incompleta'),
                  ),
                ),
                const SizedBox(height: 12),
                _buildCheckboxGroup(
                  label: 'CONSUMO DE SUSTANCIAS',
                  items: ['Toxicomanías', 'Alcoholismo', 'Tabaquismo'],
                  selectedValues: _substanceUses,
                  onChanged: (item, val) => setState(() {
                    if (val ?? false)
                      _substanceUses.add(item);
                    else
                      _substanceUses.remove(item);
                    _checkForChanges();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathologicalSection(fluent.FluentThemeData theme) {
    return fluent.Expander(
      initiallyExpanded: true,
      header: Text('ANTECEDENTES PERSONALES PATOLÓGICOS',
          style: theme.typography.subtitle),
      content: Column(
        children: [
          _buildTextField('Quirúrgicos', _controllers['surgicalHistory']!),
          _buildTextField('Traumáticos', _controllers['traumaticHistory']!),
          _buildTextField('Alérgicos', _controllers['allergicHistory']!),
          _buildTextField(
              'Transfusionales', _controllers['transfusionHistory']!),
          _buildTextField('Prueba de Coombs', _controllers['coombsTest']!),
          _buildTextField('Hipertensión Arterial Sistémica',
              _controllers['hypertensionPathological']!),
          _buildTextField('Diabetes Mellitus', _controllers['diabetes']!),
          _buildTextField('Otros Padecimientos',
              _controllers['otherPathologicalConditions']!),
        ],
      ),
    );
  }

  Widget _buildGynecologicalSection(fluent.FluentThemeData theme) {
    return fluent.Expander(
        initiallyExpanded: true,
        header: Text('ANTECEDENTES GINECO-OBSTÉTRICOS',
            style: theme.typography.subtitle),
        content: Column(
          children: [
            fluent.Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildNumberBox(
                        'Menarca',
                        _menarcheAge,
                        (val) => setState(() {
                              _menarcheAge = val;
                              _checkForChanges();
                            }),
                        suffix: 'años')),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildNumberBox(
                        'IVSA',
                        _sexualActivityStartAge,
                        (val) => setState(() {
                              _sexualActivityStartAge = val;
                              _checkForChanges();
                            }),
                        suffix: 'años')),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildNumberBox(
                        'Gesta(s)',
                        _numberOfPregnancies,
                        (val) => setState(() {
                              _numberOfPregnancies = val;
                              _checkForChanges();
                            }))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildNumberBox(
                        'Parto(s)',
                        _numberOfBirths,
                        (val) => setState(() {
                              _numberOfBirths = val;
                              _checkForChanges();
                            }))),
              ],
            ),
            const SizedBox(height: 12),
            fluent.Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildComboBox(
                        'Ritmo menstrual',
                        ['Regular', 'Irregular'],
                        _menstrualCycleRegularity,
                        (val) => setState(() {
                              _menstrualCycleRegularity = val;
                              _checkForChanges();
                            }))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildDateField(
                        'FUM',
                        _lastMenstrualPeriod,
                        (date) => setState(() {
                              _lastMenstrualPeriod = date;
                              _checkForChanges();
                            }))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildNumberBox(
                        'Aborto(s)',
                        _numberOfAbortions,
                        (val) => setState(() {
                              _numberOfAbortions = val;
                              _checkForChanges();
                            }))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildNumberBox(
                        'Cesárea(s)',
                        _numberOfCesareanSections,
                        (val) => setState(() {
                              _numberOfCesareanSections = val;
                              _checkForChanges();
                            }))),
              ],
            ),
            const SizedBox(height: 12),
            fluent.Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildTextField(
                        'LUI', _controllers['uterineCurettage']!)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildNumberBox(
                        'Hijos macrosómicos',
                        _macrosomicChildren,
                        (val) => setState(() {
                              _macrosomicChildren = val;
                              _checkForChanges();
                            }))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildNumberBox(
                        'Hijos con bajo peso al nacer',
                        _lowBirthWeightChildren,
                        (val) => setState(() {
                              _lowBirthWeightChildren = val;
                              _checkForChanges();
                            }))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildDateField(
                        'PAP',
                        _lastPapSmearDate,
                        (date) => setState(() {
                              _lastPapSmearDate = date;
                              _checkForChanges();
                            }))),
              ],
            ),
            const SizedBox(height: 12),
            fluent.Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildDateField(
                        'Fecha de Último Parto',
                        _lastDeliveryDate,
                        (date) => setState(() {
                              _lastDeliveryDate = date;
                              _checkForChanges();
                            }))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildTextField('Planificación familiar',
                        _controllers['familyPlanningMethod']!)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildTextField('Tiempo de uso de método',
                        _controllers['contraceptiveUsageDuration']!)),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ));
  }

  Widget _buildPatientInterviewSection(fluent.FluentThemeData theme) {
    return fluent.Expander(
        initiallyExpanded: true,
        header: Text('INTERROGATORIO POR APARATOS Y SISTEMAS',
            style: theme.typography.subtitle),
        content: Column(
          children: [
            _buildTextField('Revisión General de Sistemas',
                _controllers['reviewOfSystems']!),
            _buildTextField(
                'Síntomas Generales', _controllers['generalSimptoms']!),
            _buildTextField('Cabeza', _controllers['head']!),
            _buildTextField('Cuello', _controllers['neck']!),
            _buildTextField('Tórax', _controllers['thorax']!),
            _buildTextField('Abdomen', _controllers['abdomen']!),
            _buildTextField('Columna Vertebral', _controllers['backbone']!),
            _buildTextField(
                'Genitales Externos', _controllers['externalGenitalia']!),
            _buildTextField('Tacto Rectal', _controllers['rectalTouch']!),
            _buildTextField('Tacto Vaginal', _controllers['vaginalTouch']!),
            _buildTextField('Extremidades', _controllers['limbs']!),
          ],
        ));
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return fluent.InfoLabel(
      label: label,
      child: fluent.TextBox(
        controller: controller,
        maxLines: null,
      ),
    );
  }

  Widget _buildLargeTextField(String label, TextEditingController controller) {
    return fluent.InfoLabel(
      label: label,
      child: fluent.TextBox(
        controller: controller,
        maxLines: 5,
      ),
    );
  }

  Widget _buildRadioGroup({
    required String label,
    required List<String> items,
    required String? groupValue,
    required void Function(String?) onChanged,
  }) {
    return fluent.InfoLabel(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: items
            .map((item) => fluent.RadioButton(
                  checked: groupValue == item,
                  onChanged: (checked) {
                    if (checked) onChanged(item);
                  },
                  content: Text(item),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCheckboxGroup({
    required String label,
    required List<String> items,
    required Set<String> selectedValues,
    required void Function(String, bool?) onChanged,
  }) {
    return fluent.InfoLabel(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: items
            .map((item) => fluent.Checkbox(
                  checked: selectedValues.contains(item),
                  onChanged: (val) => onChanged(item, val),
                  content: Text(item),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildNumberBox(
      String label, num? value, void Function(num?) onChanged,
      {String? suffix, bool enabled = true, num step = 1, num? defaultValue}) {
    // <-- PARÁMETRO NUEVO
    return fluent.InfoLabel(
      label: label,
      child: fluent.Row(
        crossAxisAlignment: fluent.CrossAxisAlignment.center,
        children: [
          Expanded(
            child: fluent.NumberBox<num>(
              value: value ?? defaultValue ?? 0, // <-- ASÍ SE USA
              onChanged: enabled ? onChanged : null,
              mode: fluent.SpinButtonPlacementMode.inline,
              smallChange: step,
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 8),
            Text(suffix),
          ],
        ],
      ),
    );
  }

  Widget _buildComboBox(String label, List<String> items, String? value,
      void Function(String?) onChanged) {
    return fluent.InfoLabel(
      label: label,
      child: fluent.ComboBox<String>(
        value: value,
        onChanged: onChanged,
        items: items
            .map((item) => fluent.ComboBoxItem(value: item, child: Text(item)))
            .toList(),
        placeholder: const Text('Seleccionar'),
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? selectedDate, void Function(DateTime) onChanged) {
    return fluent.InfoLabel(
      label: label,
      child: fluent.DatePicker(
          selected: selectedDate, onChanged: (date) => onChanged(date)),
    );
  }
}
