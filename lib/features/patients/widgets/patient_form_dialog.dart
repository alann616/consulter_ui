import 'package:consulter_ui/core/models/enums.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:textfield_tags/textfield_tags.dart';

class PatientFormDialog extends ConsumerStatefulWidget {
  const PatientFormDialog({super.key});

  @override
  ConsumerState<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends ConsumerState<PatientFormDialog> {
  final _formKey = fluent.GlobalKey<fluent.FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // --- MODIFICACIÓN: Controlador tipado para textfield_tags ---
  late final StringTagController _allergiesController;

  Gender? _selectedGender;
  DateTime? _selectedBirthDate;

  // --- Lista de alergias comunes para el autocompletado ---
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
    'Pescado',
    'Polen',
    'Ácaros del polvo',
    'Pelo de animal',
  ];

  @override
  void initState() {
    super.initState();
    _allergiesController = StringTagController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _secondLastNameController.text.isEmpty ||
        _selectedGender == null ||
        _selectedBirthDate == null) {
      fluent.displayInfoBar(context, builder: (context, close) {
        return fluent.InfoBar(
          title: const Text('Campos requeridos'),
          content:
              const Text('Por favor, complete todos los campos marcados con *'),
          severity: fluent.InfoBarSeverity.error,
          onClose: close,
        );
      });
      return;
    }

    // --- MODIFICACIÓN: Obtenemos las alergias desde el controlador ---
    final allergiesList = _allergiesController.getTags;
    final allergiesText = (allergiesList != null && allergiesList.isNotEmpty)
        ? allergiesList.join(', ')
        : null;

    final newPatient = PatientModel(
      name: _nameController.text,
      lastName: _lastNameController.text,
      secondLastName: _secondLastNameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      allergies: allergiesText,
      gender: _selectedGender,
      birthDate: _selectedBirthDate,
    );

    ref
        .read(patientNotifierProvider.notifier)
        .createPatient(newPatient)
        .then((_) {
      if (mounted && ref.read(patientNotifierProvider).hasError == false) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientNotifierState = ref.watch(patientNotifierProvider);

    return fluent.ContentDialog(
      title: const Text('Registrar Nuevo Paciente'),
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
                  controller: _nameController,
                  placeholder: 'Ej. Juan',
                ),
              ),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                label: 'Apellido Paterno: *',
                child: fluent.TextBox(
                  controller: _lastNameController,
                  placeholder: 'Ej. Pérez',
                ),
              ),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                label: 'Apellido Materno: *',
                child: fluent.TextBox(
                  controller: _secondLastNameController,
                  placeholder: 'Ej. López',
                ),
              ),
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
                          gender == Gender.MALE ? 'Masculino' : 'Femenino'),
                    );
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
                      setState(() => _selectedBirthDate = date),
                ),
              ),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                label: 'Teléfono:',
                child: fluent.TextBox(
                  controller: _phoneController,
                  placeholder: 'Ej. 5512345678',
                ),
              ),
              const SizedBox(height: 12),
              fluent.InfoLabel(
                label: 'Email:',
                child: fluent.TextBox(
                  controller: _emailController,
                  placeholder: 'ejemplo@correo.com',
                ),
              ),
              const SizedBox(height: 12),

              // --- REEMPLAZO: Nuevo campo de Alergias con textfield_tags corregido ---
              fluent.InfoLabel(
                label: 'Alergias:',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mostramos los chips de alergias seleccionadas
                    if ((_allergiesController.getTags?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: (_allergiesController.getTags ?? [])
                              .map((String tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    fluent.FluentTheme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    tag,
                                    style: const TextStyle(
                                      color: fluent.Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _allergiesController.removeTag(tag);
                                      });
                                    },
                                    child: const Icon(
                                      fluent.FluentIcons.clear,
                                      size: 16,
                                      color: fluent.Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    // Campo de texto para agregar nuevas alergias
                    TextFieldTags<String>(
                      textfieldTagsController: _allergiesController,
                      initialTags: const [],
                      textSeparators: const [',', ' '],
                      letterCase: LetterCase.normal,
                      validator: (String tag) {
                        if ((_allergiesController.getTags ?? [])
                            .contains(tag)) {
                          return 'La alergia ya fue añadida.';
                        }
                        return null;
                      },
                      inputFieldBuilder: (context, inputFieldValues) {
                        return fluent.TextBox(
                          controller: inputFieldValues.textEditingController,
                          focusNode: inputFieldValues.focusNode,
                          placeholder: 'Escribe una alergia...',
                          onChanged: inputFieldValues.onTagChanged,
                          onSubmitted: (value) {
                            inputFieldValues.onTagSubmitted(value);
                            setState(() {}); // Actualizar la UI
                          },
                        );
                      },
                    ),
                    // Lista de sugerencias de alergias comunes
                    const SizedBox(height: 8),
                    Text(
                      'Sugerencias:',
                      style: TextStyle(
                        fontSize: 12,
                        color: fluent.FluentTheme.of(context)
                            .typography
                            .caption
                            ?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: _commonAllergies
                          .where((allergy) =>
                              !(_allergiesController.getTags ?? [])
                                  .contains(allergy))
                          .map((allergy) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _allergiesController.addTag(allergy);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: fluent.FluentTheme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color:
                                    fluent.FluentTheme.of(context).accentColor,
                              ),
                            ),
                            child: Text(
                              allergy,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
