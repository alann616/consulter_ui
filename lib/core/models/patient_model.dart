import 'package:json_annotation/json_annotation.dart';
import 'package:consulter_ui/core/models/enums.dart';

part 'patient_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PatientModel {
  final int? patientId;

  final String? publicId;

  final String? name;
  final String? lastName;
  final String? secondLastName;

  @JsonKey(
      unknownEnumValue:
          Gender.MALE) // Valor por defecto en caso de un valor desconocido
  final Gender? gender;

  final DateTime? birthDate;
  final String? allergies;
  final String? phone;
  final String? email;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  PatientModel({
    this.patientId,
    this.publicId,
    this.name,
    this.lastName,
    this.secondLastName,
    this.gender,
    this.birthDate,
    this.allergies,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
