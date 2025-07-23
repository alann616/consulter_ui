// lib/features/patients/widgets/patient_form_dialog.dart

import 'package:consulter_ui/core/models/enums.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class PatientFormDialog extends ConsumerStatefulWidget {
  final PatientModel? patient;
  const PatientFormDialog({super.key, this.patient});

  @override
  ConsumerState<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends ConsumerState<PatientFormDialog> {
  final _formKey = fluent.GlobalKey<fluent.FormState>();
  // Controladores para campos de texto simples
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _allergyInputController = TextEditingController();

  // Se maneja el estado de las alergias con una lista simple.
  final List<String> _selectedAllergies = [];

  Gender? _selectedGender;
  DateTime? _selectedBirthDate;

  bool get _isEditMode => widget.patient != null;

  final List<String> _commonAllergies = const [
    'Penicilina',
    'Aspirina',
    'Ibuprofeno',
    'Sulfamidas',
    'Látex',
    'Yodo',
    'Mariscos',
    'Nueces',
    'Cacahuates',
    'Leche',
    'Huevo',
    'Trigo',
    'Soya',
    'Pescado'
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final p = widget.patient!;
      _nameController.text = p.name ?? '';
      _lastNameController.text = p.lastName ?? '';
      _secondLastNameController.text = p.secondLastName ?? '';
      _phoneController.text = p.phone ?? '';
      _emailController.text = p.email ?? '';
      _selectedGender = p.gender;
      _selectedBirthDate = p.birthDate;

      // Se llena la lista de estado con las alergias existentes.
      if (p.allergies != null && p.allergies!.isNotEmpty) {
        _selectedAllergies.addAll(p.allergies!
            .split(',')
            .map((e) => e.trim())
            .where((s) => s.isNotEmpty));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _allergyInputController.dispose();
    super.dispose();
  }

  // Funciones para manejar la lista de alergias.
  void _addTag(String tag) {
    final cleanTag = tag.trim();
    if (cleanTag.isNotEmpty && !_selectedAllergies.contains(cleanTag)) {
      setState(() {
        _selectedAllergies.add(cleanTag);
        _allergyInputController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedAllergies.remove(tag);
    });
  }

  void _submit() {
    if (_nameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedGender == null ||
        _selectedBirthDate == null) {
      // ... (código de error sin cambios)
      return;
    }

    final allergiesText =
        _selectedAllergies.isNotEmpty ? _selectedAllergies.join(', ') : null;

    // --- CORRECCIÓN DEFINITIVA ---
    // Se crea la fecha y hora EXACTA en el momento del envío.
    final now = DateTime.now();

    final patientData = PatientModel(
      patientId: widget.patient?.patientId,
      name: _nameController.text.toUpperCase(),
      lastName: _lastNameController.text.toUpperCase(),
      secondLastName: _secondLastNameController.text.toUpperCase(),
      phone: _phoneController.text,
      email: _emailController.text,
      allergies: allergiesText,
      gender: _selectedGender,
      birthDate: _selectedBirthDate,
      // Si estamos creando (editMode es false), asignamos la fecha de creación.
      // Si estamos editando, se mantiene la original y el backend actualizará `updatedAt`.
      createdAt: _isEditMode ? widget.patient?.createdAt : now,
      updatedAt: now, // Siempre enviamos la fecha de actualización.
    );

    final notifier = ref.read(patientNotifierProvider.notifier);
    final future = _isEditMode
        ? notifier.updatePatient(
            widget.patient!.patientId!.toString(), patientData)
        : notifier.createPatient(patientData);

    future.then((_) {
      if (mounted && !ref.read(patientNotifierProvider).hasError) {
        Navigator.of(context).pop();
        if (_isEditMode) {
          ref.invalidate(
              patientDetailsProvider(widget.patient!.patientId!.toString()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientNotifierState = ref.watch(patientNotifierProvider);

    return fluent.ContentDialog(
      title: Text(_isEditMode ? 'Editar Paciente' : 'Registrar Nuevo Paciente'),
      content: SingleChildScrollView(
        child: fluent.Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fluent.InfoLabel(
                  label: 'Nombre(s): *',
                  child: fluent.TextBox(
                      controller: _nameController, placeholder: 'Ej. Juan')),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                  label: 'Apellido Paterno: *',
                  child: fluent.TextBox(
                      controller: _lastNameController,
                      placeholder: 'Ej. Pérez')),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                  label: 'Apellido Materno:',
                  child: fluent.TextBox(
                      controller: _secondLastNameController,
                      placeholder: 'Ej. López')),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                label: 'Género: *',
                child: fluent.ComboBox<Gender>(
                  value: _selectedGender,
                  placeholder: const Text('Seleccione un género'),
                  items: Gender.values.map((gender) {
                    return fluent.ComboBoxItem(
                        value: gender,
                        child: Text(
                            gender == Gender.MALE ? 'Masculino' : 'Femenino'));
                  }).toList(),
                  onChanged: (gender) =>
                      setState(() => _selectedGender = gender),
                ),
              ),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                  label: 'Fecha de Nacimiento: *',
                  child: fluent.DatePicker(
                      selected: _selectedBirthDate,
                      onChanged: (date) =>
                          setState(() => _selectedBirthDate = date))),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                  label: 'Teléfono:',
                  child: fluent.TextBox(
                      controller: _phoneController,
                      placeholder: 'Ej. 5512345678')),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                  label: 'Email:',
                  child: fluent.TextBox(
                      controller: _emailController,
                      placeholder: 'ejemplo@correo.com')),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                label: 'Alergias:',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fluent.TextBox(
                      controller: _allergyInputController,
                      placeholder: 'Escribe una alergia y presiona Enter',
                      onSubmitted: (tag) => _addTag(tag),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedAllergies.isNotEmpty)
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: _selectedAllergies
                            .map((tag) => fluent.Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4.0),
                                  decoration: fluent.BoxDecoration(
                                    color: fluent.FluentTheme.of(context)
                                        .accentColor
                                        .light,
                                    borderRadius:
                                        fluent.BorderRadius.circular(16.0),
                                  ),
                                  child: fluent.Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(tag),
                                      const SizedBox(width: 6),
                                      fluent.GestureDetector(
                                        child: const Icon(
                                            fluent.FluentIcons.cancel,
                                            size: 12.0),
                                        onTap: () => _removeTag(tag),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    if (_selectedAllergies.isNotEmpty)
                      const SizedBox(height: 16),
                    Text('Sugerencias:',
                        style:
                            fluent.FluentTheme.of(context).typography.caption),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _commonAllergies
                          .where((allergy) =>
                              !_selectedAllergies.contains(allergy))
                          .map((allergy) => fluent.Button(
                                child: Text(allergy),
                                onPressed: () => _addTag(allergy),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        fluent.FilledButton(
          onPressed: patientNotifierState.isLoading ? null : _submit,
          child: patientNotifierState.isLoading
              ? const fluent.ProgressRing(strokeWidth: 2.0)
              : const Text('Guardar'),
        ),
        fluent.Button(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
