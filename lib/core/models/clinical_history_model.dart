// lib/core/models/clinical_history_model.dart
import 'package:consulter_ui/core/models/gynecological_model.dart';
import 'package:consulter_ui/core/models/hereditary_model.dart';
import 'package:consulter_ui/core/models/non_pathological_model.dart';
import 'package:consulter_ui/core/models/pathological_model.dart';
import 'package:consulter_ui/core/models/patient_interview_model.dart';
import 'package:consulter_ui/core/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clinical_history_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClinicalHistoryModel {
  // --- Campos heredados de Document y DoctorDocument ---
  final int? documentId;
  final UserModel? doctor;
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
  final int? respiratoryRate;
  final String? currentCondition;
  final String? generalInspection;
  final String? prognosis;

  // --- Campos propios de ClinicalHistory ---
  final bool? type;
  @JsonKey(name: 'body_mass_index')
  final double? bodyMassIndex;
  @JsonKey(name: 'capillary_glycemia')
  final double? capillaryGlycemia;
  @JsonKey(name: 'cephalic_perimeter')
  final double? cephalicPerimeter;
  @JsonKey(name: 'abdominal_perimeter')
  final double? abdominalPerimeter;

  // --- Objetos anidados ---
  final HereditaryModel? hereditary;
  @JsonKey(name: 'non_pathological')
  final NonPathologicalModel? nonPathological;
  final PathologicalModel? pathological;
  final GynecologicalModel? gynecological;
  @JsonKey(name: 'patient_interview')
  final PatientInterviewModel? patientInterview;

  // --- IDs para enviar al backend ---
  @JsonKey(includeToJson: false)
  final int? doctorId;
  @JsonKey(name: 'patient_id')
  final int? patientId;

  ClinicalHistoryModel({
    this.documentId,
    this.doctor,
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
    this.respiratoryRate,
    this.currentCondition,
    this.generalInspection,
    this.prognosis,
    this.type,
    this.bodyMassIndex,
    this.capillaryGlycemia,
    this.cephalicPerimeter,
    this.abdominalPerimeter,
    this.hereditary,
    this.nonPathological,
    this.pathological,
    this.gynecological,
    this.patientInterview,
    this.doctorId,
    this.patientId,
  });

  factory ClinicalHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicalHistoryModelFromJson(json);

  Map<String, dynamic> toJson() {
    final map = _$ClinicalHistoryModelToJson(this);
    if (doctorId != null) {
      map['doctor_license'] = doctorId;
    }
    return map;
  }
}
