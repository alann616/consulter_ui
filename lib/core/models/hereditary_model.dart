// lib/core/models/hereditary_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'hereditary_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HereditaryModel {
  @JsonKey(name: 'hereditaryId')
  final int? hereditaryId;
  @JsonKey(name: 'diabetesMellitus')
  final String? diabetesMellitus;
  @JsonKey(name: 'hypertension')
  final String? hypertension;
  @JsonKey(name: 'tuberculosis')
  final String? tuberculosis;
  @JsonKey(name: 'neoplasms')
  final String? neoplasms;
  @JsonKey(name: 'heartConditions')
  final String? heartConditions;
  @JsonKey(name: 'congenitalAnomalies')
  final String? congenitalAnomalies;
  @JsonKey(name: 'endocrineDisorders')
  final String? endocrineDisorders;
  @JsonKey(name: 'otherHereditaryConditions')
  final String? otherHereditaryConditions;

  HereditaryModel({
    this.hereditaryId,
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
