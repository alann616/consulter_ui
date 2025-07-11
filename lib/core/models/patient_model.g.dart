// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientModel _$PatientModelFromJson(Map<String, dynamic> json) => PatientModel(
      patientId: (json['patientId'] as num?)?.toInt(),
      name: json['name'] as String?,
      lastName: json['lastName'] as String?,
      secondLastName: json['secondLastName'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender'],
          unknownValue: Gender.MALE),
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      allergies: json['allergies'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PatientModelToJson(PatientModel instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'name': instance.name,
      'lastName': instance.lastName,
      'secondLastName': instance.secondLastName,
      'gender': _$GenderEnumMap[instance.gender],
      'birthDate': instance.birthDate?.toIso8601String(),
      'allergies': instance.allergies,
      'phone': instance.phone,
      'email': instance.email,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.MALE: 'M',
  Gender.FEMALE: 'F',
};
