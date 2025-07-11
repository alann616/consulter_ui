// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentSummaryModel _$DocumentSummaryModelFromJson(
        Map<String, dynamic> json) =>
    DocumentSummaryModel(
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      documentId: (json['documentId'] as num?)?.toInt(),
      documentType: $enumDecodeNullable(
          _$DocumentTypeEnumMap, json['documentType'],
          unknownValue: DocumentType.EVOLUTION_NOTE),
      documentName: json['documentName'] as String?,
      doctorName: json['doctorName'] as String?,
    );

Map<String, dynamic> _$DocumentSummaryModelToJson(
        DocumentSummaryModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp?.toIso8601String(),
      'documentId': instance.documentId,
      'documentType': _$DocumentTypeEnumMap[instance.documentType],
      'documentName': instance.documentName,
      'doctorName': instance.doctorName,
    };

const _$DocumentTypeEnumMap = {
  DocumentType.PRESCRIPTION: 'PRESCRIPTION',
  DocumentType.CLINICAL_HISTORY: 'CLINICAL_HISTORY',
  DocumentType.EVOLUTION_NOTE: 'EVOLUTION_NOTE',
};
