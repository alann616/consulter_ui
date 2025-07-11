// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      doctorLicense: (json['doctorLicense'] as num?)?.toInt(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      speciality: json['speciality'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'doctorLicense': instance.doctorLicense,
      'name': instance.name,
      'phone': instance.phone,
      'speciality': instance.speciality,
    };
