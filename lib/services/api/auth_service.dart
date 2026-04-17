import 'package:insulog/services/api/api_service.dart';

class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();

  factory AuthService() => _instance;

  final ApiService _apiService = ApiService();

  Future<void> login(String username, String password) async {
    try {
      await _apiService.post('login', {
        'username': username,
        'password': password,
      });
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw AuthException('Usuario ou senha invalidos.', statusCode: 401);
      }

      if (e.statusCode == 403) {
        throw AuthException('Acesso negado.', statusCode: 403);
      }

      throw AuthException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw AuthException('Erro ao tentar logar: $e', statusCode: 500);
    }
  }

  Future<void> register(
    String username,
    String lastname,
    String email,
    String password,
  ) async {
    try {
      await _apiService.post('usuarios', {
        'nome': username+' '+lastname, 
        'email': email,
        'senha': password,
        'tipo_login': 'email',
        'tipo_usuario': 'paciente',
        'id_medico': 16
      });
    } on ApiException catch (e) {
      if (e.statusCode == 400) {
        throw AuthException(e.message, statusCode: 400);
      }
      throw AuthException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw AuthException('Erro ao tentar cadastrar: $e', statusCode: 500);
    }
  }
}

class AuthException implements Exception {
  final String message;
  final int statusCode;

  AuthException(this.message, {required this.statusCode});

  @override
  String toString() => 'AuthException: $message';
}
