class NewRegistroGlicose {
  final int nivelGlicose;
  final int periodoId;
  final DateTime horaDoRegistro;
  final DateTime dataDoRegistro;
  final int qtdInsulina;
  final int tipoInsulinaId;
  final String descricaoRegistro;

  NewRegistroGlicose({
    required this.nivelGlicose,
    required this.periodoId,
    required this.horaDoRegistro,
    required this.dataDoRegistro,
    required this.qtdInsulina,
    required this.tipoInsulinaId,
    required this.descricaoRegistro,
  });

  String get horaFormatada {
    final hour = horaDoRegistro.hour.toString().padLeft(2, '0');
    final minute = horaDoRegistro.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String get dataFormatada {
    final day = dataDoRegistro.day.toString().padLeft(2, '0');
    final month = dataDoRegistro.month.toString().padLeft(2, '0');
    final year = dataDoRegistro.year.toString();

    return '$day/$month/$year';
  }

  factory NewRegistroGlicose.fromJson(
    int nivelGlicose,
    int periodoId,
    DateTime horaDoRegistro,
    DateTime dataDoRegistro,
    int qtdInsulina,
    int tipoInsulinaId,
    String descricaoRegistro,
  ) {
    return NewRegistroGlicose(
      nivelGlicose: nivelGlicose,
      periodoId: periodoId,
      horaDoRegistro: horaDoRegistro,
      dataDoRegistro: dataDoRegistro,
      qtdInsulina: qtdInsulina,
      tipoInsulinaId: tipoInsulinaId,
      descricaoRegistro: descricaoRegistro,
    );
  }
}
