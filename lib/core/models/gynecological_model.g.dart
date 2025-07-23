// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gynecological_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GynecologicalModel _$GynecologicalModelFromJson(Map<String, dynamic> json) =>
    GynecologicalModel(
      menarcheAge: (json['menarche_age'] as num?)?.toInt(),
      menstrualCycleRegularity: json['menstrual_cycle_regularity'] as String?,
      sexualActivityStartAge:
          (json['sexual_activity_start_age'] as num?)?.toInt(),
      lastMenstrualPeriod: json['last_menstrual_period'] == null
          ? null
          : DateTime.parse(json['last_menstrual_period'] as String),
      numberOfPregnancies: (json['number_of_pregnancies'] as num?)?.toInt(),
      numberOfBirths: (json['number_of_births'] as num?)?.toInt(),
      numberOfAbortions: (json['number_of_abortions'] as num?)?.toInt(),
      numberOfCesareanSections:
          (json['number_of_cesarean_sections'] as num?)?.toInt(),
      uterineCurettage: json['uterine_curettage'] as String?,
      lastDeliveryDate: json['last_delivery_date'] == null
          ? null
          : DateTime.parse(json['last_delivery_date'] as String),
      macrosomicChildren: (json['macrosomic_children'] as num?)?.toInt(),
      lowBirthWeightChildren:
          (json['low_birth_weight_children'] as num?)?.toInt(),
      lastPapSmearDate: json['last_pap_smear_date'] == null
          ? null
          : DateTime.parse(json['last_pap_smear_date'] as String),
      familyPlanningMethod: json['family_planning_method'] as String?,
      contraceptiveUsageDuration:
          json['contraceptive_usage_duration'] as String?,
    );

Map<String, dynamic> _$GynecologicalModelToJson(GynecologicalModel instance) =>
    <String, dynamic>{
      'menarche_age': instance.menarcheAge,
      'menstrual_cycle_regularity': instance.menstrualCycleRegularity,
      'sexual_activity_start_age': instance.sexualActivityStartAge,
      'last_menstrual_period': instance.lastMenstrualPeriod?.toIso8601String(),
      'number_of_pregnancies': instance.numberOfPregnancies,
      'number_of_births': instance.numberOfBirths,
      'number_of_abortions': instance.numberOfAbortions,
      'number_of_cesarean_sections': instance.numberOfCesareanSections,
      'uterine_curettage': instance.uterineCurettage,
      'last_delivery_date': instance.lastDeliveryDate?.toIso8601String(),
      'macrosomic_children': instance.macrosomicChildren,
      'low_birth_weight_children': instance.lowBirthWeightChildren,
      'last_pap_smear_date': instance.lastPapSmearDate?.toIso8601String(),
      'family_planning_method': instance.familyPlanningMethod,
      'contraceptive_usage_duration': instance.contraceptiveUsageDuration,
    };
