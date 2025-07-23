// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hereditary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HereditaryModel _$HereditaryModelFromJson(Map<String, dynamic> json) =>
    HereditaryModel(
      diabetesMellitus: json['diabetes_mellitus'] as String?,
      hypertension: json['hypertension'] as String?,
      tuberculosis: json['tuberculosis'] as String?,
      neoplasms: json['neoplasms'] as String?,
      heartConditions: json['heart_conditions'] as String?,
      congenitalAnomalies: json['congenital_anomalies'] as String?,
      endocrineDisorders: json['endocrine_disorders'] as String?,
      otherHereditaryConditions: json['other_hereditary_conditions'] as String?,
    );

Map<String, dynamic> _$HereditaryModelToJson(HereditaryModel instance) =>
    <String, dynamic>{
      'diabetes_mellitus': instance.diabetesMellitus,
      'hypertension': instance.hypertension,
      'tuberculosis': instance.tuberculosis,
      'neoplasms': instance.neoplasms,
      'heart_conditions': instance.heartConditions,
      'congenital_anomalies': instance.congenitalAnomalies,
      'endocrine_disorders': instance.endocrineDisorders,
      'other_hereditary_conditions': instance.otherHereditaryConditions,
    };
