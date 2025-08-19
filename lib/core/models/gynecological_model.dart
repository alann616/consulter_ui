// lib/core/models/gynecological_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'gynecological_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GynecologicalModel {
  @JsonKey(name: 'menarcheAge')
  final int? menarcheAge;
  @JsonKey(name: 'menstrualCycleRegularity')
  final String? menstrualCycleRegularity;
  @JsonKey(name: 'sexualActivityStartAge')
  final int? sexualActivityStartAge;
  @JsonKey(name: 'lastMenstrualPeriod')
  final DateTime? lastMenstrualPeriod;
  @JsonKey(name: 'numberOfPregnancies')
  final int? numberOfPregnancies;
  @JsonKey(name: 'numberOfBirths')
  final int? numberOfBirths;
  @JsonKey(name: 'numberOfAbortions')
  final int? numberOfAbortions;
  @JsonKey(name: 'numberOfCesareanSections')
  final int? numberOfCesareanSections;
  @JsonKey(name: 'uterineCurettage')
  final String? uterineCurettage;
  @JsonKey(name: 'lastDeliveryDate')
  final DateTime? lastDeliveryDate;
  @JsonKey(name: 'macrosomicChildren')
  final int? macrosomicChildren;
  @JsonKey(name: 'lowBirthWeightChildren')
  final int? lowBirthWeightChildren;
  @JsonKey(name: 'lastPapSmearDate')
  final DateTime? lastPapSmearDate;
  @JsonKey(name: 'familyPlanningMethod')
  final String? familyPlanningMethod;
  @JsonKey(name: 'contraceptiveUsageDuration')
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
