// lib/core/models/clinical_history_model.dart
import 'package:consulter_ui/core/models/enums.dart';
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
  final int? documentId;
  final String? documentName;
  final DocumentType? documentType;
  final DateTime? timestamp;
  final int? doctorLicense;
  @JsonKey(name: 'patientId')
  final int? patientId;
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

  final String? type;
  @JsonKey(name: 'bodyMassIndex')
  final double? bodyMassIndex;
  @JsonKey(name: 'capillaryGlycemia')
  final double? capillaryGlycemia;
  @JsonKey(name: 'cephalicPerimeter')
  final double? cephalicPerimeter;
  @JsonKey(name: 'abdominalPerimeter')
  final double? abdominalPerimeter;

  final HereditaryModel? hereditary;
  @JsonKey(name: 'nonPathological')
  final NonPathologicalModel? nonPathological;
  final PathologicalModel? pathological;
  final GynecologicalModel? gynecological;
  @JsonKey(name: 'patientInterview')
  final PatientInterviewModel? patientInterview;

  ClinicalHistoryModel({
    this.documentId,
    this.documentName,
    this.documentType,
    this.timestamp,
    this.doctorLicense,
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
    this.patientId,
  });

  factory ClinicalHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicalHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClinicalHistoryModelToJson(this);
}
