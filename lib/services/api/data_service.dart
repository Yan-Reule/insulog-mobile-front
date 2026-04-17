import 'package:insulog/services/api/api_service.dart';

class DataService {
  DataService._();

  static final DataService _instance = DataService._();

  factory DataService() => _instance;

  final ApiService _apiService = ApiService();



  Future<List<dynamic>> fetchData(String endPoint, String usuario) async {
    try {
      final response = await _apiService.post(endPoint, {
        'nome': usuario, 
      });
      if (response is List) {
        return response;
      } else {
        throw DataException('Resposta inesperada da API.');
      }
    } on ApiException catch (e) {
      throw DataException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw DataException('Erro ao buscar dados: $e');
    }
  }
}

class DataException implements Exception{
  final String message;
  final int? statusCode;

  DataException(this.message, {this.statusCode});
}