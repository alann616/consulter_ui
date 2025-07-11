import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io'; // Para SocketException

class ConnectivityService {
  // Usamos un endpoint que debería existir en tu backend.
  // Incluso si devuelve un error 404, significa que el servidor está respondiendo.
  // El puerto 8080 se toma de tu archivo de configuración del backend.
  final String _testBackendUrl = 'http://localhost:8080/api/users/login/1';

  Future<bool> checkBackendStatus() async {
    try {
      // Establecemos un tiempo de espera para la solicitud, por ejemplo, 5 segundos.
      final response = await http
          .get(Uri.parse(_testBackendUrl))
          .timeout(const Duration(seconds: 5));

      // Cualquier respuesta del servidor (incluso 4xx o 5xx) significa que está funcionando.
      // Solo estamos verificando que sea accesible.
      if (response.statusCode >= 200 && response.statusCode < 600) {
        print(
            'Backend está respondiendo. Código de estado: ${response.statusCode}');
        return true;
      }
      print(
          'El backend respondió con un código de estado inesperado: ${response.statusCode}');
      return false;
    } on TimeoutException catch (e) {
      print('La verificación del backend excedió el tiempo de espera: $e');
      return false;
    } on SocketException catch (e) {
      // Esto típicamente significa que el servidor no es accesible (está apagado o la dirección es incorrecta).
      print('La verificación del backend falló con SocketException: $e');
      return false;
    } catch (e) {
      print(
          'Ocurrió un error inesperado durante la verificación del backend: $e');
      return false;
    }
  }
}
