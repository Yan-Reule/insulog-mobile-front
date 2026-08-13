import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_clock_register.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/services/api/data_service.dart';
import 'package:insulog/services/local/saved_login_service.dart';

class ClockState extends ChangeNotifier {
  ClockState._();

  static final ClockState instance = ClockState._();

  factory ClockState() => instance;

  List<EnumClockRegister> _registros = [];

  final SavedLoginService _savedLoginService = SavedLoginService();
  int? _recordSelectedId;
  bool _isLoading = false;
  String? _errorMessage;

  int? get recordSelectedId => _recordSelectedId;
  List<EnumClockRegister> get registros => _registros;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isRecordSelected(EnumClockRegister record) {
    return _recordSelectedId == record.idAlarme;
  }

  void onTapRecord(EnumClockRegister record) {
    _recordSelectedId = null;
    notifyListeners();
  }

  Future<void> refreshClockRecords() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var userId = Globals().userId;

    if (userId <= 0) {
      final credenciais = await _savedLoginService.getCredentials();
      userId = credenciais?.userId ?? 0;
    }

    if (userId <= 0) {
      _isLoading = false;
      _errorMessage = 'Usuario nao identificado.';
      notifyListeners();
      return;
    }

    try {
      final dados = await DataService().fetchClockData(userId);

      setRegistros(dados.registros);
    } on DataException catch (e) {
      _errorMessage = e.message;
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formataHora(DateTime dataHora) {
    final local = dataHora.toLocal();
    final hora = local.hour.toString().padLeft(2, '0');
    final minuto = local.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }

  String formataData(DateTime dataHora) {
    final local = dataHora.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    return '$dia/$mes/${local.year}';
  }

  String formataDiasSemana(List<String> diasSemana) {
    if (diasSemana.isEmpty) {
      return 'Uma vez';
    }

    const labels = {
      'DOM': 'Dom',
      'SEG': 'Seg',
      'TER': 'Ter',
      'QUA': 'Qua',
      'QUI': 'Qui',
      'SEX': 'Sex',
      'SAB': 'Sab',
    };
    return diasSemana.map((day) => labels[day] ?? day).join(', ');
  }

  String infoLembrete() {
    if (_registros.isEmpty) {
      return 'Nenhum alarme cadastrado.';
    }

    final proximoAlarme = _registros.firstWhere(
      (record) => record.ativo,
      orElse: () => _registros.first,
    );

    final hora = formataHora(proximoAlarme.dataHora);
    final diasSemana = formataDiasSemana(proximoAlarme.diasSemana);

    return 'Próximo alarme: $hora - $diasSemana';
  }

  void setRegistros(List<EnumClockRegister> registros) {
    _registros = List<EnumClockRegister>.from(registros)
      ..sort((a, b) {
        final minutosA = a.dataHora.hour * 60 + a.dataHora.minute;
        final minutosB = b.dataHora.hour * 60 + b.dataHora.minute;

        return minutosA.compareTo(minutosB);
      });

    notifyListeners();
  }

  Future<void> onLongPressRecord(
    EnumClockRegister record,
    BuildContext context,
    Size size,
  ) async {
    _recordSelectedId = record.idAlarme;
    notifyListeners();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.04),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 420,
              maxHeight: size.height * 0.78,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                  // border: Border(
                  //   top: BorderSide(color: Color(record.colorStatus), width: 6),
                  // ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.12,
                          height: size.width * 0.12,
                          decoration: BoxDecoration(
                            // color: Color(record.colorStatus).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.water_drop,
                            // color: Color(record.colorStatus),
                            size: size.width * 0.065,
                          ),
                        ),
                        SizedBox(width: size.width * 0.035),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalhes do alarme',
                                style: TextStyle(
                                  fontSize: size.width * 0.052,
                                  color: const Color(0xFF171717),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: size.height * 0.004),
                              Text(
                                '${formataData(record.dataHora)} as ${formataHora(record.dataHora)}',
                                style: TextStyle(
                                  fontSize: size.width * 0.038,
                                  color: const Color(0xFF6B6B6B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, size: size.width * 0.08),
                          color: const Color(0xFF6B6B6B),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.024),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.045,
                        vertical: size.height * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.ativo ? 'Alarme ativo' : 'Alarme inativo',
                            style: TextStyle(
                              fontSize: size.width * 0.038,
                              color: const Color(0xFF6B6B6B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: size.height * 0.004),
                          Text(
                            formataDiasSemana(record.diasSemana),
                            style: TextStyle(
                              fontSize: size.width * 0.055,
                              color: const Color(0xFF171717),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: size.height * 0.008),
                          Text(
                            'Periodo ${record.periodo}  •  Registro ${record.idRegistro}',
                            style: TextStyle(
                              fontSize: size.width * 0.038,
                              color: const Color(0xFF6B6B6B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.018),

                    SizedBox(height: size.height * 0.018),

                    SizedBox(height: size.height * 0.009),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    _recordSelectedId = null;
    notifyListeners();
  }
}
