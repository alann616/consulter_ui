// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_interview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientInterviewModel _$PatientInterviewModelFromJson(
        Map<String, dynamic> json) =>
    PatientInterviewModel(
      reviewOfSystems: json['review_of_systems'] as String?,
      generalSymptoms: json['general_symptoms'] as String?,
      head: json['head'] as String?,
      neck: json['neck'] as String?,
      thorax: json['thorax'] as String?,
      abdomen: json['abdomen'] as String?,
      backbone: json['backbone'] as String?,
      externalGenitalia: json['external_genitalia'] as String?,
      rectalTouch: json['rectal_touch'] as String?,
      vaginalTouch: json['vaginal_touch'] as String?,
      limbs: json['limbs'] as String?,
    );

Map<String, dynamic> _$PatientInterviewModelToJson(
        PatientInterviewModel instance) =>
    <String, dynamic>{
      'review_of_systems': instance.reviewOfSystems,
      'general_symptoms': instance.generalSymptoms,
      'head': instance.head,
      'neck': instance.neck,
      'thorax': instance.thorax,
      'abdomen': instance.abdomen,
      'backbone': instance.backbone,
      'external_genitalia': instance.externalGenitalia,
      'rectal_touch': instance.rectalTouch,
      'vaginal_touch': instance.vaginalTouch,
      'limbs': instance.limbs,
    };
