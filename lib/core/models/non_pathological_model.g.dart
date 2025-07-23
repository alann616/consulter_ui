// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'non_pathological_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NonPathologicalModel _$NonPathologicalModelFromJson(
        Map<String, dynamic> json) =>
    NonPathologicalModel(
      maritalStatus: json['marital_status'] as String?,
      overcrowding: json['overcrowding'] as bool?,
      promiscuity: json['promiscuity'] as bool?,
      religion: json['religion'] as String?,
      occupation: json['occupation'] as String?,
      floorMaterial: json['floor_material'] as String?,
      wallMaterial: json['wall_material'] as String?,
      services: json['services'] as String?,
      isFullyVaccinated: json['is_fully_vaccinated'] as bool?,
      substanceUse: json['substance_use'] as String?,
      isSmoker: json['is_smoker'] as String?,
      isDrinker: json['is_drinker'] as String?,
    );

Map<String, dynamic> _$NonPathologicalModelToJson(
        NonPathologicalModel instance) =>
    <String, dynamic>{
      'marital_status': instance.maritalStatus,
      'overcrowding': instance.overcrowding,
      'promiscuity': instance.promiscuity,
      'religion': instance.religion,
      'occupation': instance.occupation,
      'floor_material': instance.floorMaterial,
      'wall_material': instance.wallMaterial,
      'services': instance.services,
      'is_fully_vaccinated': instance.isFullyVaccinated,
      'substance_use': instance.substanceUse,
      'is_smoker': instance.isSmoker,
      'is_drinker': instance.isDrinker,
    };
