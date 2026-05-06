class RegistroGlicose {
  final int id;
  final DateTime horaDoRegistro;
  final String periodo;
  final int nivelGlicose;
  final int status;
  final String statusDescricao;

  RegistroGlicose({
    required this.id,
    required this.horaDoRegistro,
    required this.periodo,
    required this.nivelGlicose,
    required this.status,
    required this.statusDescricao,
  });

  String get horaFormatada {
    final hour = horaDoRegistro.hour.toString().padLeft(2, '0');
    final minute = horaDoRegistro.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  int get colorStatus {
    switch (status){
      case 0:
      return 0xFFFFC81e;
      case 1:
      return 0xFF3ea75f;
      case 2:
      return 0xFFD62828;
      default:
      return 0xFF808080;
    }
  }

  factory RegistroGlicose.fromJson(Map<String, dynamic> json) {
    return RegistroGlicose(
      id: json['id'],
      horaDoRegistro: DateTime.parse(json['horaDoRegistro']),
      periodo: json['periodo'] ?? '',
      nivelGlicose: json['nivelGlicose'],
      status: json['status'],
      statusDescricao: json['statusDescricao'],
    );
  }
}

class RegistrosGlicoseResponse {
  final int mediaDiaria;
  final int statusMediaDiaria;
  final String statusMediaDiariaDescricao;
  final List<RegistroGlicose> registros;

  RegistrosGlicoseResponse({
    required this.mediaDiaria,
    required this.statusMediaDiaria,
    required this.statusMediaDiariaDescricao,
    required this.registros,
  });

  factory RegistrosGlicoseResponse.fromJson(Map<String, dynamic> json) {
    final registrosJson = json['registros'];

    if (registrosJson is! List) {
      throw FormatException(
        'Campo "registros" deveria ser uma lista, mas veio ${registrosJson.runtimeType}: $registrosJson',
      );
    }

    return RegistrosGlicoseResponse(
      mediaDiaria: json['mediaDiaria'],
      statusMediaDiaria: json['statusMediaDiaria'],
      statusMediaDiariaDescricao: json['statusMediaDiariaDescricao'],
      registros: registrosJson
          .map((item) => RegistroGlicose.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
