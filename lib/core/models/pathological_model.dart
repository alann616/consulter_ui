// lib/core/models/pathological_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'pathological_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PathologicalModel {
  @JsonKey(name: 'surgical_history')
  final String? surgicalHistory;
  @JsonKey(name: 'transfusion_history')
  final String? transfusionHistory;
  @JsonKey(name: 'traumatic_history')
  final String? traumaticHistory;
  @JsonKey(name: 'allergic_history')
  final String? allergicHistory;
  final String? diabetes;
  final String? hypertension;
  @JsonKey(name: 'coombs_test')
  final String? coombsTest;
  @JsonKey(name: 'other_pathological_conditions')
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
