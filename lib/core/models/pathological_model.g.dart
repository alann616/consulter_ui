// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathological_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathologicalModel _$PathologicalModelFromJson(Map<String, dynamic> json) =>
    PathologicalModel(
      surgicalHistory: json['surgicalHistory'] as String?,
      transfusionHistory: json['transfusionHistory'] as String?,
      traumaticHistory: json['traumaticHistory'] as String?,
      allergicHistory: json['allergicHistory'] as String?,
      diabetes: json['diabetes'] as String?,
      hypertension: json['hypertension'] as String?,
      coombsTest: json['coombsTest'] as String?,
      otherPathologicalConditions:
          json['otherPathologicalConditions'] as String?,
    );

Map<String, dynamic> _$PathologicalModelToJson(PathologicalModel instance) =>
    <String, dynamic>{
      'surgicalHistory': instance.surgicalHistory,
      'transfusionHistory': instance.transfusionHistory,
      'traumaticHistory': instance.traumaticHistory,
      'allergicHistory': instance.allergicHistory,
      'diabetes': instance.diabetes,
      'hypertension': instance.hypertension,
      'coombsTest': instance.coombsTest,
      'otherPathologicalConditions': instance.otherPathologicalConditions,
    };
