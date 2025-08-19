// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_interview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientInterviewModel _$PatientInterviewModelFromJson(
        Map<String, dynamic> json) =>
    PatientInterviewModel(
      reviewOfSystems: json['reviewOfSystems'] as String?,
      generalSimptoms: json['generalSimptoms'] as String?,
      head: json['head'] as String?,
      neck: json['neck'] as String?,
      thorax: json['thorax'] as String?,
      abdomen: json['abdomen'] as String?,
      backbone: json['backbone'] as String?,
      externalGenitalia: json['externalGenitalia'] as String?,
      rectalTouch: json['rectalTouch'] as String?,
      vaginalTouch: json['vaginalTouch'] as String?,
      limbs: json['limbs'] as String?,
    );

Map<String, dynamic> _$PatientInterviewModelToJson(
        PatientInterviewModel instance) =>
    <String, dynamic>{
      'reviewOfSystems': instance.reviewOfSystems,
      'generalSimptoms': instance.generalSimptoms,
      'head': instance.head,
      'neck': instance.neck,
      'thorax': instance.thorax,
      'abdomen': instance.abdomen,
      'backbone': instance.backbone,
      'externalGenitalia': instance.externalGenitalia,
      'rectalTouch': instance.rectalTouch,
      'vaginalTouch': instance.vaginalTouch,
      'limbs': instance.limbs,
    };
