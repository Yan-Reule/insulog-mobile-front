import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/DTO/ENUMs/enum_registroInsulina.dart'; 
import 'package:insulog/services/api/api_service.dart';
import 'package:insulog/utils/api_date_time_formatter.dart';

class DataService {
  DataService._();

  static final DataService _instance = DataService._();

  factory DataService() => _instance;

  final ApiService _apiService = ApiService();

  Future<RegistrosGlicoseResponse> fetchData(int idUsuario, String route, bool isToday) async {
    try {
      final hoje = DateTime.now();
      final inicioDoDia = DateTime(hoje.year, hoje.month, hoje.day);
      final fimDoDia = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59);

      final response = await _apiService.get(
        '$route/usuario/$idUsuario',
        queryParameters: {
          'dataInicio': isToday ? ApiDateTimeFormatter.format(inicioDoDia) : null,
          'dataFim': isToday ? ApiDateTimeFormatter.format(fimDoDia) : null,
          "quantidade": !isToday ? 6 : null
        },
      );

      if (response is Map<String, dynamic>) {
        return RegistrosGlicoseResponse.fromJson(response);
      }

      if (response is List) {
        return RegistrosGlicoseResponse.fromList(response);
      }

      throw DataException('Resposta inesperada da API.');
    } on ApiException catch (e) {
      throw DataException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw DataException('Erro ao buscar dados: $e');
    }
  }

  Future<RegistroInsulinaResponse> fetchInsulinaData(
    int idUsuario, {
    int quantidade = 4,
  }) async {
    try {
      final response = await _apiService.get(
        'registros-insulina/usuario/$idUsuario',
        queryParameters: {
          'quantidade': quantidade,
        },
      );

      if (response is Map<String, dynamic>) {
        return RegistroInsulinaResponse.fromJson(response);
      }

      if (response is List) {
        return RegistroInsulinaResponse.fromList(response);
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
