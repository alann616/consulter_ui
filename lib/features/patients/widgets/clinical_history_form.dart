// lib/features/patients/widgets/clinical_history_form.dart

import 'package:consulter_ui/core/models/clinical_history_model.dart';
import 'package:consulter_ui/core/models/gynecological_model.dart';
import 'package:consulter_ui/core/models/hereditary_model.dart';
import 'package:consulter_ui/core/models/non_pathological_model.dart';
import 'package:consulter_ui/core/models/pathological_model.dart';
import 'package:consulter_ui/core/models/patient_interview_model.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/auth/providers/auth_provider.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  // Controladores para cada campo de texto
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Inicializar todos los controladores y llenarlos con datos existentes si los hay
    _initializeController(
        'heartConditions', widget.history?.hereditary?.heartConditions);
    _initializeController(
        'hypertensionHereditary', widget.history?.hereditary?.hypertension);
    // ... Haz esto para CADA campo de texto en todos los modelos ...

    _initializeController(
        'surgicalHistory', widget.history?.pathological?.surgicalHistory);
    // ... etc ...
  }

  void _initializeController(String key, String? value) {
    _controllers[key] = TextEditingController(text: value ?? '');
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _saveHistory() {
    final doctorId =
        ref.read(authNotifierProvider).asData?.value?.doctorLicense;
    if (doctorId == null) return;

    // Construimos el objeto completo para enviar
    final historyData = ClinicalHistoryModel(
      documentId: widget.history?.documentId,
      patientId: widget.patient.patientId,
      doctorId: doctorId,
      hereditary: HereditaryModel(
        heartConditions: _controllers['heartConditions']?.text,
        hypertension: _controllers['hypertensionHereditary']?.text,
        // ... poblar todos los campos
      ),
      pathological: PathologicalModel(
        surgicalHistory: _controllers['surgicalHistory']?.text,
        // ... poblar todos los campos
      ),
      // ... poblar el resto de los objetos anidados ...
    );

    ref.read(patientNotifierProvider.notifier).saveClinicalHistory(historyData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: const Text('Historia Clínica'),
        commandBar: fluent.CommandBar(
          mainAxisAlignment: fluent.MainAxisAlignment.end,
          primaryItems: [
            fluent.CommandBarButton(
              icon: const Icon(fluent.FluentIcons.save),
              label: const Text('Guardar Cambios'),
              onPressed: _saveHistory,
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildHereditarySection(theme),
            const SizedBox(height: 16),
            _buildPathologicalSection(theme),
            const SizedBox(height: 16),
            // ... Aquí irían las llamadas a los builders de las otras secciones ...
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS PARA CADA SECCIÓN ---

  Widget _buildHereditarySection(fluent.FluentThemeData theme) {
    return fluent.Expander(
      header: Text('Antecedentes Heredofamiliares',
          style: theme.typography.subtitle),
      content: Column(
        children: [
          _buildTextField('Cardiopatías', _controllers['heartConditions']!),
          _buildTextField(
              'Hipertensión', _controllers['hypertensionHereditary']!),
          // ... y así para todos los campos de esta sección ...
        ],
      ),
    );
  }

  Widget _buildPathologicalSection(fluent.FluentThemeData theme) {
    return fluent.Expander(
      header:
          Text('Antecedentes Patológicos', style: theme.typography.subtitle),
      content: Column(
        children: [
          _buildTextField('Quirúrgicos', _controllers['surgicalHistory']!),
          // ... y así para todos los campos de esta sección ...
        ],
      ),
    );
  }

  // Widget de ayuda para no repetir código
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: fluent.InfoLabel(
        label: label,
        child: fluent.TextBox(controller: controller),
      ),
    );
  }
}
