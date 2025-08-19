// lib/core/models/patient_interview_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'patient_interview_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PatientInterviewModel {
  @JsonKey(name: 'reviewOfSystems')
  final String? reviewOfSystems;
  @JsonKey(name: 'generalSimptoms')
  final String? generalSimptoms;
  @JsonKey(name: 'head')
  final String? head;
  @JsonKey(name: 'neck')
  final String? neck;
  @JsonKey(name: 'thorax')
  final String? thorax;
  @JsonKey(name: 'abdomen')
  final String? abdomen;
  @JsonKey(name: 'backbone')
  final String? backbone;
  @JsonKey(name: 'externalGenitalia')
  final String? externalGenitalia;
  @JsonKey(name: 'rectalTouch')
  final String? rectalTouch;
  @JsonKey(name: 'vaginalTouch')
  final String? vaginalTouch;
  @JsonKey(name: 'limbs')
  final String? limbs;

  PatientInterviewModel({
    this.reviewOfSystems,
    this.generalSimptoms,
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
