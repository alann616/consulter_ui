// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hereditary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HereditaryModel _$HereditaryModelFromJson(Map<String, dynamic> json) =>
    HereditaryModel(
      hereditaryId: (json['hereditaryId'] as num?)?.toInt(),
      diabetesMellitus: json['diabetesMellitus'] as String?,
      hypertension: json['hypertension'] as String?,
      tuberculosis: json['tuberculosis'] as String?,
      neoplasms: json['neoplasms'] as String?,
      heartConditions: json['heartConditions'] as String?,
      congenitalAnomalies: json['congenitalAnomalies'] as String?,
      endocrineDisorders: json['endocrineDisorders'] as String?,
      otherHereditaryConditions: json['otherHereditaryConditions'] as String?,
    );

Map<String, dynamic> _$HereditaryModelToJson(HereditaryModel instance) =>
    <String, dynamic>{
      'hereditaryId': instance.hereditaryId,
      'diabetesMellitus': instance.diabetesMellitus,
      'hypertension': instance.hypertension,
      'tuberculosis': instance.tuberculosis,
      'neoplasms': instance.neoplasms,
      'heartConditions': instance.heartConditions,
      'congenitalAnomalies': instance.congenitalAnomalies,
      'endocrineDisorders': instance.endocrineDisorders,
      'otherHereditaryConditions': instance.otherHereditaryConditions,
    };
