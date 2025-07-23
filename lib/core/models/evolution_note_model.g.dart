// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evolution_note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvolutionNoteModel _$EvolutionNoteModelFromJson(Map<String, dynamic> json) =>
    EvolutionNoteModel(
      documentId: (json['documentId'] as num?)?.toInt(),
      doctor: json['doctor'] == null
          ? null
          : UserModel.fromJson(json['doctor'] as Map<String, dynamic>),
      doctorId: (json['doctor_license'] as num?)?.toInt(),
      patient: json['patient'] == null
          ? null
          : PatientModel.fromJson(json['patient'] as Map<String, dynamic>),
      patientId: (json['patient_id'] as num?)?.toInt(),
      documentName: json['documentName'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      bodyTemp: (json['bodyTemp'] as num?)?.toDouble(),
      oxygenSaturation: (json['oxygenSaturation'] as num?)?.toInt(),
      heartRate: (json['heartRate'] as num?)?.toInt(),
      systolicBP: (json['systolicBP'] as num?)?.toInt(),
      diastolicBP: (json['diastolicBP'] as num?)?.toInt(),
      treatment: json['treatment'] as String?,
      diagnosticImpression: json['diagnosticImpression'] as String?,
      instructions: json['instructions'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      documentType:
          $enumDecodeNullable(_$DocumentTypeEnumMap, json['documentType']) ??
              DocumentType.EVOLUTION_NOTE,
      respiratoryRate: (json['respiratoryRate'] as num?)?.toInt(),
      currentCondition: json['currentCondition'] as String?,
      generalInspection: json['generalInspection'] as String?,
      prognosis: json['prognosis'] as String?,
      treatmentPlan: json['treatmentPlan'] as String?,
      laboratoryResults: json['laboratoryResults'] as String?,
    );

Map<String, dynamic> _$EvolutionNoteModelToJson(EvolutionNoteModel instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'doctor': instance.doctor?.toJson(),
      'doctor_license': instance.doctorId,
      'patient': instance.patient?.toJson(),
      'patient_id': instance.patientId,
      'documentName': instance.documentName,
      'weight': instance.weight,
      'height': instance.height,
      'bodyTemp': instance.bodyTemp,
      'oxygenSaturation': instance.oxygenSaturation,
      'heartRate': instance.heartRate,
      'systolicBP': instance.systolicBP,
      'diastolicBP': instance.diastolicBP,
      'treatment': instance.treatment,
      'diagnosticImpression': instance.diagnosticImpression,
      'instructions': instance.instructions,
      'timestamp': instance.timestamp?.toIso8601String(),
      'documentType': _$DocumentTypeEnumMap[instance.documentType],
      'respiratoryRate': instance.respiratoryRate,
      'currentCondition': instance.currentCondition,
      'generalInspection': instance.generalInspection,
      'prognosis': instance.prognosis,
      'treatmentPlan': instance.treatmentPlan,
      'laboratoryResults': instance.laboratoryResults,
    };

const _$DocumentTypeEnumMap = {
  DocumentType.PRESCRIPTION: 'PRESCRIPTION',
  DocumentType.CLINICAL_HISTORY: 'CLINICAL_HISTORY',
  DocumentType.EVOLUTION_NOTE: 'EVOLUTION_NOTE',
};
