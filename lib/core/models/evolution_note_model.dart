// lib/core/models/evolution_note_model.dart

import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/core/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:consulter_ui/core/models/enums.dart';

part 'evolution_note_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EvolutionNoteModel {
  // === Campos de la clase base 'Document' ===
  final int? documentId;

  final UserModel? doctor;

  @JsonKey(name: 'doctor_license')
  final int? doctorId;

  final PatientModel? patient;

  @JsonKey(name: 'patient_id')
  final int? patientId;

  final String? documentName;
  final double? weight;
  final double? height;
  final double? bodyTemp;
  final int? oxygenSaturation;
  final int? heartRate;
  final int? systolicBP;
  final int? diastolicBP;
  final String? treatment;
  final String? diagnosticImpression;
  final String? instructions;
  final DateTime? timestamp;

  // === Campos de la clase 'DoctorDocument' ===
  @JsonKey(
    // Asignamos el valor por defecto directamente en el modelo
    defaultValue: DocumentType.EVOLUTION_NOTE,
  )
  final DocumentType? documentType;
  final int? respiratoryRate;
  final String? currentCondition;
  final String? generalInspection;
  final String? prognosis;

  // === Campos de la clase 'EvolutionNote' ===
  final String? treatmentPlan;
  final String? laboratoryResults;

  String get doctorName => doctor?.name ?? 'Desconocido';

  EvolutionNoteModel({
    this.documentId,
    this.doctor,
    this.doctorId,
    this.patient,
    this.patientId,
    this.documentName,
    this.weight,
    this.height,
    this.bodyTemp,
    this.oxygenSaturation,
    this.heartRate,
    this.systolicBP,
    this.diastolicBP,
    this.treatment,
    this.diagnosticImpression,
    this.instructions,
    this.timestamp,
    // Se añade documentType al constructor
    this.documentType = DocumentType.EVOLUTION_NOTE,
    this.respiratoryRate,
    this.currentCondition,
    this.generalInspection,
    this.prognosis,
    this.treatmentPlan,
    this.laboratoryResults,
  });

  factory EvolutionNoteModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionNoteModelFromJson(json);
  Map<String, dynamic> toJson() {
    final map = _$EvolutionNoteModelToJson(this);
    // Añadimos manualmente el 'doctor_license' que el DTO del backend espera.
    if (doctorId != null) {
      map['doctor_license'] = doctorId;
    }
    return map;
  }
}
