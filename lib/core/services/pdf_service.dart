// lib/core/services/pdf_service.dart

import 'dart:typed_data';
import 'package:consulter_ui/core/models/clinical_history_model.dart';
import 'package:consulter_ui/core/models/enums.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfService {
  // La función principal que llamaremos desde la UI
  static Future<Uint8List> generateClinicalHistoryPdf(
    PatientModel patient,
    ClinicalHistoryModel history,
  ) async {
    final pdf = pw.Document();

    // Carga las imágenes de fondo para cada página
    final page1Bg =
        await _loadBackgroundImage('assets/images/ClinicalHistoryP1.png');
    final page2Bg =
        await _loadBackgroundImage('assets/images/ClinicalHistoryP2.png');
    final page3Bg =
        await _loadBackgroundImage('assets/images/ClinicalHistoryP3.png');
    final page4Bg =
        await _loadBackgroundImage('assets/images/ClinicalHistoryP4.png');

    // Añade cada página al PDF
    pdf.addPage(_buildPage1(patient, history, page1Bg));
    pdf.addPage(_buildPage2(history, page2Bg));
    pdf.addPage(_buildPage3(patient, history, page3Bg));
    pdf.addPage(_buildPage4(history, page4Bg));

    // Guarda el documento en memoria y lo devuelve como bytes
    return pdf.save();
  }

  // --- MÉTODOS AUXILIARES ---

  // Carga la imagen de fondo desde los assets
  static Future<pw.MemoryImage> _loadBackgroundImage(String path) async {
    final bytes = await rootBundle.load(path);
    return pw.MemoryImage(bytes.buffer.asUint8List());
  }

  static pw.Widget _buildText(String text, double left, double top,
      {double? width,
      double size = 12,
      double? lineSpacing,
      PdfColor color = PdfColors.black}) {
    return pw.Positioned(
      left: left,
      top: top,
      child: pw.Container(
        width: width,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: size,
            color: color,
            lineSpacing: lineSpacing,
          ),
        ),
      ),
    );
  }

  // --- CONSTRUCCIÓN DE CADA PÁGINA ---

  static pw.Page _buildPage1(PatientModel patient, ClinicalHistoryModel history,
      pw.MemoryImage background) {
    final DateFormat dateFormat = DateFormat('dd / MM / yyyy');
    final DateFormat hourFormat = DateFormat('HH:mm');
    final String patientAge =
        (DateTime.now().year - (patient.birthDate?.year ?? 0)).toString();
    final String formattedIMC = history.bodyMassIndex!.toStringAsFixed(2);

    return pw.Page(
      margin: const pw.EdgeInsets.all(0),
      pageFormat: PdfPageFormat.letter,
      build: (context) {
        return pw.Stack(
          children: [
            pw.Image(background, fit: pw.BoxFit.fill),
            // Datos de la historia clínica
            _buildText(
                history.timestamp != null
                    ? dateFormat.format(history.timestamp!)
                    : 'N/A',
                367,
                50), // Fecha
            _buildText(
                history.timestamp != null
                    ? hourFormat.format(history.timestamp!)
                    : 'N/A',
                360,
                77),
            _buildText(history.documentId?.toString() ?? 'N/A', 400,
                103), // ID Historia

            // Datos del paciente
            _buildText(
                '${patient.name} ${patient.lastName} ${patient.secondLastName}',
                139,
                188), // Nombre
            _buildText('$patientAge años', 115, 222), // Edad
            _buildText(
                patient.gender.toString().split('.').last == 'MALE'
                    ? 'Masculino'
                    : 'Femenino',
                360,
                222), // Sexo
            _buildText(
                (patient.phone == null || patient.phone!.trim().isEmpty)
                    ? 'No especificado'
                    : patient.phone!,
                200,
                255), // Teléfono
            _buildText(
                patient.email == null || patient.email!.trim().isEmpty
                    ? 'No especificado'
                    : patient.email!,
                190,
                290), // Correo Electrónico
            _buildText(patient.allergies ?? 'Negadas', 135, 322,
                width: 405), // Alergias

            // Signos vitales y medidas antropométricas
            _buildText('${history.weight?.toString()} kg', 90, 410), // Peso
            _buildText('${history.height?.toString()} m', 225, 410), // Talla
            _buildText('${history.bodyTemp?.toString()} °C', 355,
                410), // Temp. Corporal
            _buildText('${history.diastolicBP} / ${history.systolicBP} mmHg',
                470, 410), // Presión Arterial

            _buildText('${history.heartRate?.toString()} lpm', 90, 445), // FC
            _buildText('${history.oxygenSaturation?.toString()}%', 285,
                445), // Sat. O2
            _buildText('$formattedIMC kg/m²', 460, 445), // IMC

            _buildText('${history.cephalicPerimeter?.toString()} cm', 105,
                484), // Perímetro Cefálico
            _buildText('${history.abdominalPerimeter?.toString()} cm', 295,
                484), // Perímetro Abdominal
            _buildText('${history.capillaryGlycemia?.toStringAsFixed(2)}', 467,
                484), // Glucosa Capilar

            _buildText(history.diagnosticImpression ?? '', 45, 545,
                width: 518), // Impresión Diagnóstica

            // Campos grandes
            _buildText(history.currentCondition ?? '', 38, 618,
                size: 12, width: 538, lineSpacing: 2), // Padecimiento Actual
          ],
        );
      },
    );
  }

  static pw.Page _buildPage2(
      ClinicalHistoryModel history, pw.MemoryImage background) {
    return pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (context) {
        return pw.Stack(
          children: [
            pw.Image(background, fit: pw.BoxFit.fill),
            // Mapea aquí los datos de Antecedentes Hereditarios y No Patológicos
            // Fuente: ClinicalHistory.pdf
            _buildText(history.hereditary?.diabetesMellitus ?? '', 80, 55),
            _buildText(history.nonPathological?.maritalStatus ?? '', 120, 240),
            // ...etc.
          ],
        );
      },
    );
  }

  static pw.Page _buildPage3(PatientModel patient, ClinicalHistoryModel history,
      pw.MemoryImage background) {
    final isFemale = patient.gender == Gender.FEMALE;
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (context) {
        return pw.Stack(
          children: [
            pw.Image(background, fit: pw.BoxFit.fill),
            // Mapea aquí los datos de Antecedentes Ginecológicos y Examen Físico
            // Fuente: ClinicalHistory.pdf
            if (isFemale && history.gynecological != null) ...[
              _buildText(history.gynecological!.menarcheAge?.toString() ?? '',
                  100, 55),
              _buildText(
                  history.gynecological!.numberOfPregnancies?.toString() ?? '',
                  320,
                  55),
              _buildText(
                  history.gynecological!.lastMenstrualPeriod != null
                      ? dateFormat
                          .format(history.gynecological!.lastMenstrualPeriod!)
                      : '',
                  320,
                  100),
              // ...etc.
            ]
          ],
        );
      },
    );
  }

  static pw.Page _buildPage4(
      ClinicalHistoryModel history, pw.MemoryImage background) {
    return pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (context) {
        return pw.Stack(
          children: [
            pw.Image(background, fit: pw.BoxFit.fill),
            // Mapea aquí el resto del Examen, Tratamiento e Impresión Diagnóstica
            // Fuente: ClinicalHistory.pdf
            _buildText(history.patientInterview?.backbone ?? '', 45, 70),
            _buildText(history.treatment ?? '', 45, 400),
            _buildText(history.diagnosticImpression ?? '', 45, 530),
            // ...etc.
          ],
        );
      },
    );
  }
}
