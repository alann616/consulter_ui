import 'package:json_annotation/json_annotation.dart';
import 'package:consulter_ui/core/models/enums.dart';

part 'document_summary_model.g.dart';

@JsonSerializable()
class DocumentSummaryModel {
  final int documentId;
  final DateTime timestamp;

  // Usamos un valor desconocido por si en el futuro añades tipos que la app vieja no conoce
  @JsonKey(unknownEnumValue: DocumentType.EVOLUTION_NOTE)
  final DocumentType documentType;

  final String? documentName;
  final String? doctorName;

  DocumentSummaryModel({
    required this.documentId,
    required this.timestamp,
    required this.documentType,
    this.documentName,
    this.doctorName,
  });

  factory DocumentSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentSummaryModelToJson(this);
}
