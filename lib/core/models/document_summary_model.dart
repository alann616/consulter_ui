import 'package:json_annotation/json_annotation.dart';
import 'package:consulter_ui/core/models/enums.dart';

part 'document_summary_model.g.dart';

@JsonSerializable()
class DocumentSummaryModel {
  final DateTime? timestamp;
  final int? documentId;

  @JsonKey(unknownEnumValue: DocumentType.EVOLUTION_NOTE)
  final DocumentType? documentType;

  final String? documentName;
  final String? doctorName;

  DocumentSummaryModel({
    this.timestamp,
    this.documentId,
    this.documentType,
    this.documentName,
    this.doctorName,
  });

  factory DocumentSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentSummaryModelToJson(this);
}
