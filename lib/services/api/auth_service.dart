import 'package:insulog/services/api/api_service.dart';

class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();

  factory AuthService() => _instance;

  final ApiService _apiService = ApiService();

  Future<LoginData> login(String username, String password) async {
    try {
      final response = await _apiService.post('login', {
        'username': username,
        'password': password,
      });

      if (response is Map<String, dynamic>) {
        final userId = _readUserId(response);
        final token = _readToken(response);

        if (userId != null && token != null) {
          return LoginData(userId: userId, token: token);
        }
      }

      throw AuthException(
        'Login realizado, mas a API nao retornou o id do usuario.',
        statusCode: 500,
      );
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw AuthException('Usuario ou senha invalidos.', statusCode: 401);
      }

      if (e.statusCode == 403) {
        throw AuthException('Acesso negado.', statusCode: 403);
      }

      throw AuthException(e.message, statusCode: e.statusCode);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Erro ao tentar logar: $e', statusCode: 500);
    }
  }

  int? _readUserId(Map<String, dynamic> json) {
    final directId = _parseId(json['id_usuario'] ?? json['idUsuario'] ?? json['id']);

    if (directId != null) {
      return directId;
    }

    final usuario = json['usuario'] ?? json['user'] ?? json['data'];

    if (usuario is Map<String, dynamic>) {
      return _parseId(
        usuario['id_usuario'] ?? usuario['idUsuario'] ?? usuario['id'],
      );
    }

    return null;
  }

  String? _readToken(Map<String, dynamic> json) {
    final user = json['user'] ?? json['usuario'] ?? json['data'];
    final token = user is Map<String, dynamic> ? user['token'] : json['token'];
    return token is String && token.isNotEmpty ? token : null;
  }

  int? _parseId(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  Future<void> register(
    String username,
    String lastname,
    String email,
    String password,
  ) async {
    final fullName = [username.trim(), lastname.trim()]
        .where((part) => part.isNotEmpty)
        .join(' ');

    try {
      await _apiService.post('usuarios', {
        'nome': fullName,
        'email': email,
        'senha': password,
        'tipo_login': 'email',
        'tipo_usuario': 'paciente',
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

  Future<Map<String, dynamic>> getDoctorLink() async {
    try {
      final response = await _apiService.get('pacientes/vinculo');
      if (response is Map<String, dynamic>) return response;
      throw AuthException('Resposta inesperada ao buscar vinculo.', statusCode: 500);
    } on ApiException catch (e) {
      throw AuthException(e.message, statusCode: e.statusCode);
    }
  }

  Future<void> redeemDoctorLink(String code) async {
    try {
      await _apiService.post('pacientes/vinculo', {
        'codigo_vinculo': code.trim().toUpperCase(),
      });
    } on ApiException catch (e) {
      throw AuthException(e.message, statusCode: e.statusCode);
    }
  }
}

class LoginData {
  final int userId;
  final String token;

  const LoginData({required this.userId, required this.token});
}

class AuthException implements Exception {
  final String message;
  final int statusCode;

  AuthException(this.message, {required this.statusCode});

  @override
  String toString() => 'AuthException: $message';
}
