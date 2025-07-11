import 'package:consulter_ui/core/models/user_model.dart';
import 'package:consulter_ui/core/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este StateNotifier ahora solo gestiona el estado en memoria.
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;
  AuthNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> login(String license) async {
    state = const AsyncValue.loading();
    try {
      final user =
          await _ref.read(apiServiceProvider).loginUserByLicense(license);
      // Ya no guardamos nada en SharedPreferences. El estado solo vive aquí.
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Logout simplemente limpia el estado en memoria.
  Future<void> logout() async {
    state = const AsyncValue.data(null);
  }
}

// El provider para nuestro Notifier (sin cambios)
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref);
});
