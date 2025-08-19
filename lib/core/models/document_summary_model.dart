// lib/core/models/document_summary_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:consulter_ui/core/models/enums.dart';

part 'document_summary_model.g.dart';

@JsonSerializable()
class DocumentSummaryModel {
  final int documentId;
  final DateTime timestamp;

  @JsonKey(unknownEnumValue: DocumentType.EVOLUTION_NOTE)
  final DocumentType? documentType;

  final String? documentName;
  final String? doctorName;
  final String? patientName;

  DocumentSummaryModel({
    required this.documentId,
    required this.timestamp,
    required this.documentType,
    this.documentName,
    this.doctorName,
    this.patientName,
  });

  factory DocumentSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentSummaryModelToJson(this);
}
