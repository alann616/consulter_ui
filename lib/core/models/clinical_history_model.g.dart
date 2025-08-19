// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicalHistoryModel _$ClinicalHistoryModelFromJson(
        Map<String, dynamic> json) =>
    ClinicalHistoryModel(
      documentId: (json['documentId'] as num?)?.toInt(),
      documentName: json['documentName'] as String?,
      documentType:
          $enumDecodeNullable(_$DocumentTypeEnumMap, json['documentType']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      doctorLicense: (json['doctorLicense'] as num?)?.toInt(),
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
      respiratoryRate: (json['respiratoryRate'] as num?)?.toInt(),
      currentCondition: json['currentCondition'] as String?,
      generalInspection: json['generalInspection'] as String?,
      prognosis: json['prognosis'] as String?,
      type: json['type'] as String?,
      bodyMassIndex: (json['bodyMassIndex'] as num?)?.toDouble(),
      capillaryGlycemia: (json['capillaryGlycemia'] as num?)?.toDouble(),
      cephalicPerimeter: (json['cephalicPerimeter'] as num?)?.toDouble(),
      abdominalPerimeter: (json['abdominalPerimeter'] as num?)?.toDouble(),
      hereditary: json['hereditary'] == null
          ? null
          : HereditaryModel.fromJson(
              json['hereditary'] as Map<String, dynamic>),
      nonPathological: json['nonPathological'] == null
          ? null
          : NonPathologicalModel.fromJson(
              json['nonPathological'] as Map<String, dynamic>),
      pathological: json['pathological'] == null
          ? null
          : PathologicalModel.fromJson(
              json['pathological'] as Map<String, dynamic>),
      gynecological: json['gynecological'] == null
          ? null
          : GynecologicalModel.fromJson(
              json['gynecological'] as Map<String, dynamic>),
      patientInterview: json['patientInterview'] == null
          ? null
          : PatientInterviewModel.fromJson(
              json['patientInterview'] as Map<String, dynamic>),
      patientId: (json['patientId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClinicalHistoryModelToJson(
        ClinicalHistoryModel instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'documentName': instance.documentName,
      'documentType': _$DocumentTypeEnumMap[instance.documentType],
      'timestamp': instance.timestamp?.toIso8601String(),
      'doctorLicense': instance.doctorLicense,
      'patientId': instance.patientId,
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
      'respiratoryRate': instance.respiratoryRate,
      'currentCondition': instance.currentCondition,
      'generalInspection': instance.generalInspection,
      'prognosis': instance.prognosis,
      'type': instance.type,
      'bodyMassIndex': instance.bodyMassIndex,
      'capillaryGlycemia': instance.capillaryGlycemia,
      'cephalicPerimeter': instance.cephalicPerimeter,
      'abdominalPerimeter': instance.abdominalPerimeter,
      'hereditary': instance.hereditary?.toJson(),
      'nonPathological': instance.nonPathological?.toJson(),
      'pathological': instance.pathological?.toJson(),
      'gynecological': instance.gynecological?.toJson(),
      'patientInterview': instance.patientInterview?.toJson(),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.PRESCRIPTION: 'PRESCRIPTION',
  DocumentType.CLINICAL_HISTORY: 'CLINICAL_HISTORY',
  DocumentType.EVOLUTION_NOTE: 'EVOLUTION_NOTE',
};
