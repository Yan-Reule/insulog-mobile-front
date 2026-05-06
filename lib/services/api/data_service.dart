import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/services/api/api_service.dart';

class DataService {
  DataService._();

  static final DataService _instance = DataService._();

  factory DataService() => _instance;

  final ApiService _apiService = ApiService();

  String formatDateTime(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute:$second';
  }

  Future<RegistrosGlicoseResponse> fetchData(
    String endPoint,
    int idUsuario,
  ) async {
    try {
      final hoje = DateTime.now();
      final inicioDoDia = DateTime(hoje.year, hoje.month, hoje.day);
      final fimDoDia = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59);

      final response = await _apiService.get(endPoint, queryParameters: {
        'id_usuario': idUsuario,
        'dataInicio': formatDateTime(inicioDoDia),
        'dataFim': formatDateTime(fimDoDia),
      });

      if (response is Map<String, dynamic>) {
        return RegistrosGlicoseResponse.fromJson(response);
      }

      throw DataException('Resposta inesperada da API.');
    } on ApiException catch (e) {
      throw DataException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw DataException('Erro ao buscar dados: $e');
    }
  }
}

class DataException implements Exception {
  final String message;
  final int? statusCode;

  DataException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode == null) {
      return 'DataException: $message';
    }

    return 'DataException: $message (Status code: $statusCode)';
  }
}
