import 'dart:convert';
import 'dart:io' show Platform;
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
      headers: {'Content-Type': 'application/json'},
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

  // --- FUNCIÓN CORREGIDA ---
  Future<PatientModel> getPatientById(String id) async {
    // Usamos 'id', que es el nombre del parámetro
    final response = await _client
        .get(Uri.parse('$_baseUrl/patients/$id')); // <-- CORRECCIÓN 1
    if (response.statusCode == 200) {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return PatientModel.fromJson(data);
    } else {
      // Usamos 'id' también en el mensaje de error
      throw Exception(
          'Fallo al obtener el paciente (ID: $id)'); // <-- CORRECCIÓN 2
    }
  }
  // -------------------------

  Future<PatientModel> createPatient(PatientModel patientData) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/patients/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patientData.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return PatientModel.fromJson(data);
    } else {
      throw Exception('Fallo al crear el paciente');
    }
  }

  Future<PatientModel> updatePatient(
      String id, PatientModel patientData) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/patients/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patientData.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return PatientModel.fromJson(data);
    } else {
      throw Exception('Fallo al actualizar el paciente (ID: $id)');
    }
  }

  Future<void> deletePatient(String id) async {
    final response =
        await _client.delete(Uri.parse('$_baseUrl/patients/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Fallo al eliminar el paciente (ID: $id)');
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

  void dispose() {
    _client.close();
  }
}
