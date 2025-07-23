// lib/core/models/non_pathological_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'non_pathological_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NonPathologicalModel {
  @JsonKey(name: 'marital_status')
  final String? maritalStatus;
  final bool? overcrowding;
  final bool? promiscuity;
  final String? religion;
  final String? occupation;
  @JsonKey(name: 'floor_material')
  final String? floorMaterial;
  @JsonKey(name: 'wall_material')
  final String? wallMaterial;
  final String? services;
  @JsonKey(name: 'is_fully_vaccinated')
  final bool? isFullyVaccinated;
  @JsonKey(name: 'substance_use')
  final String? substanceUse;
  @JsonKey(name: 'is_smoker')
  final String? isSmoker;
  @JsonKey(name: 'is_drinker')
  final String? isDrinker;

  NonPathologicalModel({
    this.maritalStatus,
    this.overcrowding,
    this.promiscuity,
    this.religion,
    this.occupation,
    this.floorMaterial,
    this.wallMaterial,
    this.services,
    this.isFullyVaccinated,
    this.substanceUse,
    this.isSmoker,
    this.isDrinker,
  });

  factory NonPathologicalModel.fromJson(Map<String, dynamic> json) =>
      _$NonPathologicalModelFromJson(json);
  Map<String, dynamic> toJson() => _$NonPathologicalModelToJson(this);
}
