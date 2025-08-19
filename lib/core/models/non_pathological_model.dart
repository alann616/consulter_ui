// lib/core/models/non_pathological_model.dart
import 'package:consulter_ui/core/util/bool_from_int_converter.dart'; // <-- AÑADE ESTA LÍNEA
import 'package:json_annotation/json_annotation.dart';

part 'non_pathological_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NonPathologicalModel {
  @JsonKey(name: 'maritalStatus')
  final String? maritalStatus;
  final bool? overcrowding;
  final bool? promiscuity;
  final String? religion;
  final String? occupation;
  @JsonKey(name: 'floorMaterial')
  final String? floorMaterial;
  @JsonKey(name: 'wallMaterial')
  final String? wallMaterial;
  final String? services;

  @JsonKey(name: 'isFullyVaccinated')
  final bool? isFullyVaccinated;

  @JsonKey(name: 'substanceUse')
  final String? substanceUse;
  @JsonKey(name: 'isSmoker')
  final String? isSmoker;
  @JsonKey(name: 'isDrinker')
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
