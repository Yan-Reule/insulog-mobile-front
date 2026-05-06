import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  ApiService._();

  static final ApiService _instance = ApiService._();

  factory ApiService() => _instance;

  final String _baseUrl = 'http://192.168.137.1:3000';

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> post(String endPoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl/$endPoint');
    var data;

    try {
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw ApiException(
          message:
              data['message'] ??
              'Erro na API ' + response.statusCode.toString(),
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException(
        message: 'Tempo de resposta excedido. Tente novamente.',
        statusCode: 408,
      );
    } on SocketException {
      throw ApiException(
        message: 'Nao foi possivel conectar ao servidor.',
        statusCode: 503,
      );
    }
  }

  Future<dynamic> get(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final formattedQueryParameters = queryParameters?.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    final uri = Uri.parse(
      '$_baseUrl/$endPoint',
    ).replace(queryParameters: formattedQueryParameters);
    var data;

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw ApiException(
          message:
              data['message'] ??
              'Erro na API ' + response.statusCode.toString(),
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException(
        message: 'Tempo de resposta excedido. Tente novamente.',
        statusCode: 408,
      );
    } on SocketException {
      throw ApiException(
        message: 'Nao foi possivel conectar ao servidor.',
        statusCode: 503,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message (Status code: $statusCode)';
  }
}
