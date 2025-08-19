// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'non_pathological_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NonPathologicalModel _$NonPathologicalModelFromJson(
        Map<String, dynamic> json) =>
    NonPathologicalModel(
      maritalStatus: json['maritalStatus'] as String?,
      overcrowding: json['overcrowding'] as bool?,
      promiscuity: json['promiscuity'] as bool?,
      religion: json['religion'] as String?,
      occupation: json['occupation'] as String?,
      floorMaterial: json['floorMaterial'] as String?,
      wallMaterial: json['wallMaterial'] as String?,
      services: json['services'] as String?,
      isFullyVaccinated: json['isFullyVaccinated'] as bool?,
      substanceUse: json['substanceUse'] as String?,
      isSmoker: json['isSmoker'] as String?,
      isDrinker: json['isDrinker'] as String?,
    );

Map<String, dynamic> _$NonPathologicalModelToJson(
        NonPathologicalModel instance) =>
    <String, dynamic>{
      'maritalStatus': instance.maritalStatus,
      'overcrowding': instance.overcrowding,
      'promiscuity': instance.promiscuity,
      'religion': instance.religion,
      'occupation': instance.occupation,
      'floorMaterial': instance.floorMaterial,
      'wallMaterial': instance.wallMaterial,
      'services': instance.services,
      'isFullyVaccinated': instance.isFullyVaccinated,
      'substanceUse': instance.substanceUse,
      'isSmoker': instance.isSmoker,
      'isDrinker': instance.isDrinker,
    };
