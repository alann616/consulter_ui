// lib/features/auth/providers/patient_filter_provider.dart

import 'package:consulter_ui/core/models/patient_model.dart';
import 'package:consulter_ui/features/patients/providers/patient_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOption { registrationNewest, registrationOldest, ageDesc, ageAsc }

final patientSearchProvider = StateProvider.autoDispose<String>((ref) => '');
final patientSortProvider = StateProvider.autoDispose<SortOption>(
    (ref) => SortOption.registrationNewest);

// Este proveedor ahora maneja los estados de carga/error/datos.
final filteredAndSortedPatientsProvider =
    Provider.autoDispose<AsyncValue<List<PatientModel>>>((ref) {
  final patientsAsyncValue = ref.watch(allPatientsProvider);

  return patientsAsyncValue.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (patients) {
      final searchTerm = ref.watch(patientSearchProvider).toLowerCase();
      final sortOption = ref.watch(patientSortProvider);

      final filteredPatients = patients.where((patient) {
        if (searchTerm.isEmpty) return true;
        return (patient.name?.toLowerCase().contains(searchTerm) ?? false) ||
            (patient.lastName?.toLowerCase().contains(searchTerm) ?? false) ||
            (patient.secondLastName?.toLowerCase().contains(searchTerm) ??
                false) ||
            (patient.phone?.contains(searchTerm) ?? false) ||
            (patient.email?.toLowerCase().contains(searchTerm) ?? false);
      }).toList();

      filteredPatients.sort((a, b) {
        switch (sortOption) {
          case SortOption.ageDesc:
            return (a.birthDate ?? DateTime(1900))
                .compareTo(b.birthDate ?? DateTime(1900));
          case SortOption.ageAsc:
            return (b.birthDate ?? DateTime(1900))
                .compareTo(a.birthDate ?? DateTime(1900));
          case SortOption.registrationOldest:
            return (a.createdAt ?? DateTime(1900))
                .compareTo(b.createdAt ?? DateTime(1900));
          case SortOption.registrationNewest:
          default:
            return (b.createdAt ?? DateTime(1900))
                .compareTo(a.createdAt ?? DateTime(1900));
        }
      });

      return AsyncValue.data(filteredPatients);
    },
  );
});
