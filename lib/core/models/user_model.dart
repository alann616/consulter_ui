import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? doctorLicense;
  final String? name;
  final String? phone;
  final String? speciality;

  UserModel({
    this.doctorLicense,
    this.name,
    this.phone,
    this.speciality,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
