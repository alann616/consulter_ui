import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/core/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para la lista completa (sin cambios)
final allPatientsProvider =
    FutureProvider.autoDispose<List<PatientModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getAllPatients();
});

// --- ¡NUEVO PROVIDER! ---
// Usamos .family para poder pasarle un argumento (el ID del paciente).
// Obtendrá los detalles de un solo paciente.
final patientDetailsProvider = FutureProvider.autoDispose
    .family<PatientModel, String>((ref, patientId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPatientById(patientId);
});

final selectedPatientIdProvider = StateProvider<String?>((ref) => null);

// Notifier para CUD (sin cambios)
class PatientNotifier extends StateNotifier<AsyncValue<void>> {
  // ... (sin cambios)
  final Ref _ref;
  PatientNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> createPatient(PatientModel patient) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(apiServiceProvider).createPatient(patient);
      _ref.invalidate(allPatientsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePatient(String id, PatientModel patient) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(apiServiceProvider).updatePatient(id, patient);
      _ref.invalidate(allPatientsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePatient(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(apiServiceProvider).deletePatient(id);
      _ref.invalidate(allPatientsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final patientNotifierProvider =
    StateNotifierProvider<PatientNotifier, AsyncValue<void>>((ref) {
  return PatientNotifier(ref);
});
