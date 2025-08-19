// lib/core/models/pathological_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'pathological_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PathologicalModel {
  @JsonKey(name: 'surgicalHistory')
  final String? surgicalHistory;
  @JsonKey(name: 'transfusionHistory')
  final String? transfusionHistory;
  @JsonKey(name: 'traumaticHistory')
  final String? traumaticHistory;
  @JsonKey(name: 'allergicHistory')
  final String? allergicHistory;
  @JsonKey(name: 'diabetes')
  final String? diabetes;
  @JsonKey(name: 'hypertension')
  final String? hypertension;
  @JsonKey(name: 'coombsTest')
  final String? coombsTest;
  @JsonKey(name: 'otherPathologicalConditions')
  final String? otherPathologicalConditions;

  PathologicalModel({
    this.surgicalHistory,
    this.transfusionHistory,
    this.traumaticHistory,
    this.allergicHistory,
    this.diabetes,
    this.hypertension,
    this.coombsTest,
    this.otherPathologicalConditions,
  });

  factory PathologicalModel.fromJson(Map<String, dynamic> json) =>
      _$PathologicalModelFromJson(json);
  Map<String, dynamic> toJson() => _$PathologicalModelToJson(this);
}
