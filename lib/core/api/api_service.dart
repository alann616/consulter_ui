// lib/core/api/api_service.dart

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:consulter_ui/core/models/clinical_history_model.dart';
import 'package:consulter_ui/core/models/document_summary_model.dart';
import 'package:consulter_ui/core/models/evolution_note_model.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/core/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8080/api'
      : 'http://localhost:8080/api';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // === Endpoints de Usuario ===
  Future<UserModel> loginUserByLicense(String license) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/users/login/$license'));
    if (response.statusCode == 200) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } else {
      throw Exception('Fallo al iniciar sesión (Licencia: $license)');
    }
  }

  Future<UserModel> updateUserProfile(
      String license, UserModel userDetails) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/users/$license'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(userDetails.toJson()),
    );
    if (response.statusCode == 200) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } else {
      throw Exception('Fallo al actualizar perfil (Licencia: $license)');
    }
  }

  // === Endpoints de Pacientes ===
  Future<List<PatientModel>> getAllPatients() async {
    final response = await _client.get(Uri.parse('$_baseUrl/patients'));
    if (response.statusCode == 200) {
      final List<dynamic> dataList =
          jsonDecode(utf8.decode(response.bodyBytes));
      return dataList.map((data) => PatientModel.fromJson(data)).toList();
    } else {
      throw Exception('Fallo al obtener todos los pacientes');
    }
  }

  Future<PatientModel> getPatientById(String id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/patients/$id'));
    if (response.statusCode == 200) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return PatientModel.fromJson(data);
    } else {
      throw Exception('Fallo al obtener el paciente (ID: $id)');
    }
  }

  // --- CORRECCIÓN AQUÍ ---
  Future<PatientModel> createPatient(PatientModel patientData) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/patients/create'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(patientData.toJson()),
    );

    // Se acepta 201 (Creado) como éxito
    if (response.statusCode == 201) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return PatientModel.fromJson(data);
    } else {
      // Si hay otro código, se lanza una excepción con el detalle del error del backend.
      final errorBody = utf8.decode(response.bodyBytes);
      print(
          'Error al crear paciente. Código: ${response.statusCode}, Cuerpo: $errorBody');
      throw Exception(
          'Fallo al crear el paciente. Código: ${response.statusCode}. Error: $errorBody');
    }
  }

  Future<PatientModel> updatePatient(
      String id, PatientModel patientData) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/patients/update/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(patientData.toJson()),
    );
    if (response.statusCode == 200) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return PatientModel.fromJson(data);
    } else {
      throw Exception('Fallo al actualizar el paciente (ID: $id)');
    }
  }

  Future<void> deletePatient(String id) async {
    final response =
        await _client.delete(Uri.parse('$_baseUrl/patients/delete/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      // Aceptar 204 No Content
      throw Exception('Fallo al eliminar el paciente (ID: $id)');
    }
  }

  // === Endpoints de Documentos ===
  Future<List<DocumentSummaryModel>> getDocumentHistory(
      String patientId) async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/documents/history?patientId=$patientId'));
    if (response.statusCode == 200) {
      final List<dynamic> dataList =
          jsonDecode(utf8.decode(response.bodyBytes));
      return dataList
          .map((data) => DocumentSummaryModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Fallo al obtener el historial de documentos');
    }
  }

  Future<List<EvolutionNoteModel>> getEvolutionNotesByPatientId(
      String patientId) async {
    final response = await _client.get(
        Uri.parse('$_baseUrl/evolution-notes/by-patient?patientId=$patientId'));
    if (response.statusCode == 200) {
      final List<dynamic> dataList =
          jsonDecode(utf8.decode(response.bodyBytes));
      return dataList.map((data) => EvolutionNoteModel.fromJson(data)).toList();
    } else {
      throw Exception(
          'Fallo al obtener las notas de evolución (Paciente ID: $patientId)');
    }
  }

  Future<EvolutionNoteModel> createEvolutionNote(
      EvolutionNoteModel noteData) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/evolution-notes/create'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(noteData.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return EvolutionNoteModel.fromJson(data);
    } else {
      final errorBody = utf8.decode(response.bodyBytes);
      print(
          'Error al crear nota. Código: ${response.statusCode}, Cuerpo: $errorBody');
      throw Exception(
          'Fallo al crear la nota de evolución. Código: ${response.statusCode}. Error: $errorBody');
    }
  }

  Future<ClinicalHistoryModel?> getClinicalHistoryByPatientId(
      String patientId) async {
    final response = await _client.get(Uri.parse(
        '$_baseUrl/clinical-histories/by-patient?patientId=$patientId'));
    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == "null") {
        return null;
      }
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return ClinicalHistoryModel.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(
          'Fallo al obtener la historia clínica del paciente (ID: $patientId)');
    }
  }

  Future<ClinicalHistoryModel> saveClinicalHistory(
      ClinicalHistoryModel historyData) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/clinical-histories/save'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(historyData.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return ClinicalHistoryModel.fromJson(data);
    } else {
      throw Exception('Fallo al guardar la historia clínica: ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }
}
