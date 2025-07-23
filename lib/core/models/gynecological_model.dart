// lib/core/models/gynecological_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'gynecological_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GynecologicalModel {
  @JsonKey(name: 'menarche_age')
  final int? menarcheAge;
  @JsonKey(name: 'menstrual_cycle_regularity')
  final String? menstrualCycleRegularity;
  @JsonKey(name: 'sexual_activity_start_age')
  final int? sexualActivityStartAge;
  @JsonKey(name: 'last_menstrual_period')
  final DateTime? lastMenstrualPeriod;
  @JsonKey(name: 'number_of_pregnancies')
  final int? numberOfPregnancies;
  @JsonKey(name: 'number_of_births')
  final int? numberOfBirths;
  @JsonKey(name: 'number_of_abortions')
  final int? numberOfAbortions;
  @JsonKey(name: 'number_of_cesarean_sections')
  final int? numberOfCesareanSections;
  @JsonKey(name: 'uterine_curettage')
  final String? uterineCurettage;
  @JsonKey(name: 'last_delivery_date')
  final DateTime? lastDeliveryDate;
  @JsonKey(name: 'macrosomic_children')
  final int? macrosomicChildren;
  @JsonKey(name: 'low_birth_weight_children')
  final int? lowBirthWeightChildren;
  @JsonKey(name: 'last_pap_smear_date')
  final DateTime? lastPapSmearDate;
  @JsonKey(name: 'family_planning_method')
  final String? familyPlanningMethod;
  @JsonKey(name: 'contraceptive_usage_duration')
  final String? contraceptiveUsageDuration;

  GynecologicalModel({
    this.menarcheAge,
    this.menstrualCycleRegularity,
    this.sexualActivityStartAge,
    this.lastMenstrualPeriod,
    this.numberOfPregnancies,
    this.numberOfBirths,
    this.numberOfAbortions,
    this.numberOfCesareanSections,
    this.uterineCurettage,
    this.lastDeliveryDate,
    this.macrosomicChildren,
    this.lowBirthWeightChildren,
    this.lastPapSmearDate,
    this.familyPlanningMethod,
    this.contraceptiveUsageDuration,
  });

  factory GynecologicalModel.fromJson(Map<String, dynamic> json) =>
      _$GynecologicalModelFromJson(json);
  Map<String, dynamic> toJson() => _$GynecologicalModelToJson(this);
}
