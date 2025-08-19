// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gynecological_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GynecologicalModel _$GynecologicalModelFromJson(Map<String, dynamic> json) =>
    GynecologicalModel(
      menarcheAge: (json['menarcheAge'] as num?)?.toInt(),
      menstrualCycleRegularity: json['menstrualCycleRegularity'] as String?,
      sexualActivityStartAge: (json['sexualActivityStartAge'] as num?)?.toInt(),
      lastMenstrualPeriod: json['lastMenstrualPeriod'] == null
          ? null
          : DateTime.parse(json['lastMenstrualPeriod'] as String),
      numberOfPregnancies: (json['numberOfPregnancies'] as num?)?.toInt(),
      numberOfBirths: (json['numberOfBirths'] as num?)?.toInt(),
      numberOfAbortions: (json['numberOfAbortions'] as num?)?.toInt(),
      numberOfCesareanSections:
          (json['numberOfCesareanSections'] as num?)?.toInt(),
      uterineCurettage: json['uterineCurettage'] as String?,
      lastDeliveryDate: json['lastDeliveryDate'] == null
          ? null
          : DateTime.parse(json['lastDeliveryDate'] as String),
      macrosomicChildren: (json['macrosomicChildren'] as num?)?.toInt(),
      lowBirthWeightChildren: (json['lowBirthWeightChildren'] as num?)?.toInt(),
      lastPapSmearDate: json['lastPapSmearDate'] == null
          ? null
          : DateTime.parse(json['lastPapSmearDate'] as String),
      familyPlanningMethod: json['familyPlanningMethod'] as String?,
      contraceptiveUsageDuration: json['contraceptiveUsageDuration'] as String?,
    );

Map<String, dynamic> _$GynecologicalModelToJson(GynecologicalModel instance) =>
    <String, dynamic>{
      'menarcheAge': instance.menarcheAge,
      'menstrualCycleRegularity': instance.menstrualCycleRegularity,
      'sexualActivityStartAge': instance.sexualActivityStartAge,
      'lastMenstrualPeriod': instance.lastMenstrualPeriod?.toIso8601String(),
      'numberOfPregnancies': instance.numberOfPregnancies,
      'numberOfBirths': instance.numberOfBirths,
      'numberOfAbortions': instance.numberOfAbortions,
      'numberOfCesareanSections': instance.numberOfCesareanSections,
      'uterineCurettage': instance.uterineCurettage,
      'lastDeliveryDate': instance.lastDeliveryDate?.toIso8601String(),
      'macrosomicChildren': instance.macrosomicChildren,
      'lowBirthWeightChildren': instance.lowBirthWeightChildren,
      'lastPapSmearDate': instance.lastPapSmearDate?.toIso8601String(),
      'familyPlanningMethod': instance.familyPlanningMethod,
      'contraceptiveUsageDuration': instance.contraceptiveUsageDuration,
    };
