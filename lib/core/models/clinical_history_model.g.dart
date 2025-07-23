// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicalHistoryModel _$ClinicalHistoryModelFromJson(
        Map<String, dynamic> json) =>
    ClinicalHistoryModel(
      documentId: (json['documentId'] as num?)?.toInt(),
      doctor: json['doctor'] == null
          ? null
          : UserModel.fromJson(json['doctor'] as Map<String, dynamic>),
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
      type: json['type'] as bool?,
      bodyMassIndex: (json['body_mass_index'] as num?)?.toDouble(),
      capillaryGlycemia: (json['capillary_glycemia'] as num?)?.toDouble(),
      cephalicPerimeter: (json['cephalic_perimeter'] as num?)?.toDouble(),
      abdominalPerimeter: (json['abdominal_perimeter'] as num?)?.toDouble(),
      hereditary: json['hereditary'] == null
          ? null
          : HereditaryModel.fromJson(
              json['hereditary'] as Map<String, dynamic>),
      nonPathological: json['non_pathological'] == null
          ? null
          : NonPathologicalModel.fromJson(
              json['non_pathological'] as Map<String, dynamic>),
      pathological: json['pathological'] == null
          ? null
          : PathologicalModel.fromJson(
              json['pathological'] as Map<String, dynamic>),
      gynecological: json['gynecological'] == null
          ? null
          : GynecologicalModel.fromJson(
              json['gynecological'] as Map<String, dynamic>),
      patientInterview: json['patient_interview'] == null
          ? null
          : PatientInterviewModel.fromJson(
              json['patient_interview'] as Map<String, dynamic>),
      doctorId: (json['doctorId'] as num?)?.toInt(),
      patientId: (json['patient_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClinicalHistoryModelToJson(
        ClinicalHistoryModel instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'doctor': instance.doctor?.toJson(),
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
      'body_mass_index': instance.bodyMassIndex,
      'capillary_glycemia': instance.capillaryGlycemia,
      'cephalic_perimeter': instance.cephalicPerimeter,
      'abdominal_perimeter': instance.abdominalPerimeter,
      'hereditary': instance.hereditary?.toJson(),
      'non_pathological': instance.nonPathological?.toJson(),
      'pathological': instance.pathological?.toJson(),
      'gynecological': instance.gynecological?.toJson(),
      'patient_interview': instance.patientInterview?.toJson(),
      'patient_id': instance.patientId,
    };
