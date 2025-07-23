// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathological_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathologicalModel _$PathologicalModelFromJson(Map<String, dynamic> json) =>
    PathologicalModel(
      surgicalHistory: json['surgical_history'] as String?,
      transfusionHistory: json['transfusion_history'] as String?,
      traumaticHistory: json['traumatic_history'] as String?,
      allergicHistory: json['allergic_history'] as String?,
      diabetes: json['diabetes'] as String?,
      hypertension: json['hypertension'] as String?,
      coombsTest: json['coombs_test'] as String?,
      otherPathologicalConditions:
          json['other_pathological_conditions'] as String?,
    );

Map<String, dynamic> _$PathologicalModelToJson(PathologicalModel instance) =>
    <String, dynamic>{
      'surgical_history': instance.surgicalHistory,
      'transfusion_history': instance.transfusionHistory,
      'traumatic_history': instance.traumaticHistory,
      'allergic_history': instance.allergicHistory,
      'diabetes': instance.diabetes,
      'hypertension': instance.hypertension,
      'coombs_test': instance.coombsTest,
      'other_pathological_conditions': instance.otherPathologicalConditions,
    };
