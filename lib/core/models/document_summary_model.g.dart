// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentSummaryModel _$DocumentSummaryModelFromJson(
        Map<String, dynamic> json) =>
    DocumentSummaryModel(
      documentId: (json['documentId'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      documentType: $enumDecode(_$DocumentTypeEnumMap, json['documentType'],
          unknownValue: DocumentType.EVOLUTION_NOTE),
      documentName: json['documentName'] as String?,
      doctorName: json['doctorName'] as String?,
    );

Map<String, dynamic> _$DocumentSummaryModelToJson(
        DocumentSummaryModel instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'timestamp': instance.timestamp.toIso8601String(),
      'documentType': _$DocumentTypeEnumMap[instance.documentType]!,
      'documentName': instance.documentName,
      'doctorName': instance.doctorName,
    };

const _$DocumentTypeEnumMap = {
  DocumentType.PRESCRIPTION: 'PRESCRIPTION',
  DocumentType.CLINICAL_HISTORY: 'CLINICAL_HISTORY',
  DocumentType.EVOLUTION_NOTE: 'EVOLUTION_NOTE',
};
