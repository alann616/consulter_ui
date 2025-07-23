// lib/core/models/patient_interview_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'patient_interview_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PatientInterviewModel {
  @JsonKey(name: 'review_of_systems')
  final String? reviewOfSystems;
  @JsonKey(name: 'general_symptoms')
  final String? generalSymptoms;
  final String? head;
  final String? neck;
  final String? thorax;
  final String? abdomen;
  final String? backbone;
  @JsonKey(name: 'external_genitalia')
  final String? externalGenitalia;
  @JsonKey(name: 'rectal_touch')
  final String? rectalTouch;
  @JsonKey(name: 'vaginal_touch')
  final String? vaginalTouch;
  final String? limbs;

  PatientInterviewModel({
    this.reviewOfSystems,
    this.generalSymptoms,
    this.head,
    this.neck,
    this.thorax,
    this.abdomen,
    this.backbone,
    this.externalGenitalia,
    this.rectalTouch,
    this.vaginalTouch,
    this.limbs,
  });

  factory PatientInterviewModel.fromJson(Map<String, dynamic> json) =>
      _$PatientInterviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatientInterviewModelToJson(this);
}
