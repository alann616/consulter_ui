import 'package:json_annotation/json_annotation.dart';

part 'evolution_note_model.g.dart';

@JsonSerializable()
class EvolutionNoteModel {
  // Campos de Document
  final int? documentId;
  final int? doctorId; // Asumimos que el JSON tendrá el ID
  final int? patientId; // Asumimos que el JSON tendrá el ID
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

  // Campos de DoctorDocument
  final int? respiratoryRate;
  final String? currentCondition;
  final String? generalInspection;
  final String? prognosis;

  // Campos de EvolutionNote
  final String? treatmentPlan;
  final String? laboratoryResults;

  EvolutionNoteModel({
    this.documentId,
    this.doctorId,
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
    this.respiratoryRate,
    this.currentCondition,
    this.generalInspection,
    this.prognosis,
    this.treatmentPlan,
    this.laboratoryResults,
  });

  factory EvolutionNoteModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionNoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$EvolutionNoteModelToJson(this);
}
