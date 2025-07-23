// lib/core/models/hereditary_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'hereditary_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HereditaryModel {
  @JsonKey(name: 'diabetes_mellitus')
  final String? diabetesMellitus;
  final String? hypertension;
  final String? tuberculosis;
  final String? neoplasms;
  @JsonKey(name: 'heart_conditions')
  final String? heartConditions;
  @JsonKey(name: 'congenital_anomalies')
  final String? congenitalAnomalies;
  @JsonKey(name: 'endocrine_disorders')
  final String? endocrineDisorders;
  @JsonKey(name: 'other_hereditary_conditions')
  final String? otherHereditaryConditions;

  HereditaryModel({
    this.diabetesMellitus,
    this.hypertension,
    this.tuberculosis,
    this.neoplasms,
    this.heartConditions,
    this.congenitalAnomalies,
    this.endocrineDisorders,
    this.otherHereditaryConditions,
  });

  factory HereditaryModel.fromJson(Map<String, dynamic> json) =>
      _$HereditaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$HereditaryModelToJson(this);
}
