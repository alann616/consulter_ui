import 'package:consulter_ui/core/models/clinical_history_model.dart';
import 'package:consulter_ui/core/models/document_summary_model.dart';
import 'package:consulter_ui/core/models/evolution_note_model.dart';
import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/core/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para la lista completa (sin cambios)
final allPatientsProvider =
    FutureProvider.autoDispose<List<PatientModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getAllPatients();
});

// Provider para los detalles de un solo paciente (sin cambios)
final patientDetailsProvider = FutureProvider.autoDispose
    .family<PatientModel, String>((ref, patientId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPatientById(patientId);
});

// Provider para las notas de evolución de un paciente
final evolutionNotesProvider = FutureProvider.autoDispose
    .family<List<EvolutionNoteModel>, String>((ref, patientId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getEvolutionNotesByPatientId(patientId);
});

// Provider para la historia clínica de un paciente
final clinicalHistoryProvider = FutureProvider.autoDispose
    .family<ClinicalHistoryModel?, String>((ref, patientId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getClinicalHistoryByPatientId(patientId);
});

final selectedPatientIdProvider = StateProvider<String?>((ref) => null);

// Notifier para todas las operaciones CUD (Crear, Actualizar, Borrar)
class PatientNotifier extends StateNotifier<AsyncValue<void>> {
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

  Future<void> createEvolutionNote(EvolutionNoteModel note) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(apiServiceProvider).createEvolutionNote(note);
      // Cuando se crea una nota, invalidamos el provider para que la lista se refresque.
      _ref.invalidate(evolutionNotesProvider(note.patientId.toString()));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // --- CORRECCIÓN: Este método ahora está DENTRO de la clase PatientNotifier ---
  Future<void> saveClinicalHistory(ClinicalHistoryModel history) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(apiServiceProvider).saveClinicalHistory(history);
      // Invalidamos el provider de la historia clínica para que se refresquen los datos.
      _ref.invalidate(clinicalHistoryProvider(history.patientId.toString()));
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

final documentHistoryProvider = FutureProvider.autoDispose
    .family<List<DocumentSummaryModel>, String>((ref, patientId) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getDocumentHistory(patientId);
});

final allDocumentsProvider =
    FutureProvider.autoDispose<List<DocumentSummaryModel>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getAllDocuments();
});
