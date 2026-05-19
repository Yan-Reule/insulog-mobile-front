import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_form_registroGlicose.dart';
import 'package:insulog/DTO/ENUMs/enum_periodo_registroGlicose.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/DTO/ENUMs/enum_registroInsulina.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/services/api/data_service.dart';
import 'package:insulog/services/local/saved_login_service.dart';

class GlucoseRecordFormScreenState extends ChangeNotifier {
  final _controller = PageController();
  PageController get controller => _controller;

  int step = 0;
  late List<RegistroGlicose> registrosGlicose = [];
  late List<RegistroInsulina> registrosInsulina = [];
  late List<EnumPeriodo> periodos = [];
  String mediaGlicose = '';
  final SavedLoginService _savedLoginService = SavedLoginService();

  final TextEditingController _glucoseImputController = TextEditingController();
  final TextEditingController _insulinaImputController =
      TextEditingController();
  final String userId = Globals().userId.toString();
  int _nivelGlicose = 0;
  int _periodoId = 0;
  DateTime _horaDoRegistro = DateTime.now();
  DateTime _dataDoRegistro = DateTime.now();
  int _unidadeInsulina = 0;
  int _tipoInsulinaId = 0;
  String _observacao = '';
  Timer? _glucoseHoldTimer;
  bool _glucoseHoldChangedValue = false;
  Timer? _insulinaHoldTimer;
  bool _insulinaHoldChangedValue = false;

  int get nivelGlicose => _nivelGlicose;
  int get periodoId => _periodoId;
  DateTime get horaDoRegistro => _horaDoRegistro;
  DateTime get dataDoRegistro => _dataDoRegistro;
  int get unidadeInsulina => _unidadeInsulina;
  int get tipoInsulinaId => _tipoInsulinaId;
  String get observacao => _observacao;

  bool get glicosePreenchida => _nivelGlicose > 0;
  bool get periodoPreenchido => _periodoId > 0;
  bool get insulinaPreenchida => _unidadeInsulina > 0 && _tipoInsulinaId > 0;

  NewRegistroGlicose get novoRegistro => NewRegistroGlicose(
    idUsuario: userId,
    nivelGlicose: _nivelGlicose,
    periodoId: _periodoId,
    horaDoRegistro: _horaDoRegistro,
    dataDoRegistro: _dataDoRegistro,
    unidadeInsulina: _unidadeInsulina,
    tipoInsulinaId: _tipoInsulinaId,
    observacao: _observacao,
  );

  TextEditingController get glucoseImputController => _glucoseImputController;
  TextEditingController get insulinaImputController => _insulinaImputController;

  String returnTextPeriodo() {
    switch (_periodoId) {
      case 1:
        return 'VARIAS HORAS SEM COMER';
      case 2:
        return 'ANTES DE COMER';
      case 3:
        return 'DEPOIS DE COMER';
      case 4:
        return 'ANTES DE DORMIR';
      default:
        return 'SELECIONE UM PERÍODO';
    }
  }

  void usarRegistro(int glucoseValue) {
    _setNivelGlicose(glucoseValue);
    if (step == 0) {
      next();
    }
  }

  void usarRegistroInsulina(RegistroInsulina registro) {
    _setUnidadeInsulina(registro.unidadeInsulina);
    atualizarTipoInsulina(registro.idTipoInsulina);
  }

  void atualizarNivelGlicose(String value) {
    _setNivelGlicose(int.tryParse(value) ?? 0, atualizarController: false);
  }

  void incrementarNivelGlicose() {
    if (_glucoseHoldChangedValue) {
      _glucoseHoldChangedValue = false;
      return;
    }

    _setNivelGlicose(_nivelGlicose + 1);
  }

  void decrementarNivelGlicose() {
    if (_glucoseHoldChangedValue) {
      _glucoseHoldChangedValue = false;
      return;
    }

    _setNivelGlicose(_nivelGlicose - 1);
  }

  void iniciarIncrementoContinuoGlicose() {
    _iniciarAlteracaoContinuaGlicose(10);
  }

  void iniciarDecrementoContinuoGlicose() {
    _iniciarAlteracaoContinuaGlicose(-10);
  }

  void pararAlteracaoContinuaGlicose() {
    _glucoseHoldTimer?.cancel();
    _glucoseHoldTimer = null;
  }

  void incrementarUnidadeInsulina() {
    if (_insulinaHoldChangedValue) {
      _insulinaHoldChangedValue = false;
      return;
    }

    _setUnidadeInsulina(_unidadeInsulina + 1);
  }

  void decrementarUnidadeInsulina() {
    if (_insulinaHoldChangedValue) {
      _insulinaHoldChangedValue = false;
      return;
    }

    _setUnidadeInsulina(_unidadeInsulina - 1);
  }

  void iniciarIncrementoContinuoInsulina() {
    _iniciarAlteracaoContinuaInsulina(1);
  }

  void iniciarDecrementoContinuoInsulina() {
    _iniciarAlteracaoContinuaInsulina(-1);
  }

  void pararAlteracaoContinuaInsulina() {
    _insulinaHoldTimer?.cancel();
    _insulinaHoldTimer = null;
  }

  void _iniciarAlteracaoContinuaGlicose(int valor) {
    pararAlteracaoContinuaGlicose();
    _glucoseHoldChangedValue = false;

    _glucoseHoldTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      _glucoseHoldChangedValue = true;
      _setNivelGlicose(_nivelGlicose + valor);
    });
  }

  void _iniciarAlteracaoContinuaInsulina(int valor) {
    pararAlteracaoContinuaInsulina();
    _insulinaHoldChangedValue = false;

    _insulinaHoldTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      _insulinaHoldChangedValue = true;
      _setUnidadeInsulina(_unidadeInsulina + valor);
    });
  }

  void _setNivelGlicose(int value, {bool atualizarController = true}) {
    _nivelGlicose = value.clamp(0, 999).toInt();

    if (atualizarController) {
      _glucoseImputController.text = _nivelGlicose == 0
          ? ''
          : _nivelGlicose.toString();
    }

    notifyListeners();
  }

  void _setUnidadeInsulina(int value, {bool atualizarController = true}) {
    _unidadeInsulina = value.clamp(0, 999).toInt();

    if (atualizarController) {
      _insulinaImputController.text = _unidadeInsulina == 0
          ? ''
          : _unidadeInsulina.toString();
    }

    notifyListeners();
  }

  void atualizarPeriodo(int value) {
    if (_periodoId == 0) {
      if (step == 1) {
        next();
      }
    }

    _periodoId = value;

    notifyListeners();
  }

  void atualizarHoraDoRegistro(DateTime value) {
    _horaDoRegistro = value;
    notifyListeners();
  }

  void atualizarDataDoRegistro(DateTime value) {
    _dataDoRegistro = value;
    notifyListeners();
  }

  void atualizarUnidadeInsulina(String value) {
    _setUnidadeInsulina(int.tryParse(value) ?? 0, atualizarController: false);
  }

  void atualizarTipoInsulina(int value) {
    _tipoInsulinaId = value;
    notifyListeners();
  }

  void atualizarObservacao(String value) {
    _observacao = value;
    notifyListeners();
  }

  void next() {
    if (step < 3) {
      step++;
      _controller.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void back() {
    if (step > 0) {
      step--;
      _controller.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  Future<void> refreshRecords() async {
    var userId = Globals().userId;

    if (userId <= 0) {
      final credenciais = await _savedLoginService.getCredentials();
      userId = credenciais?.userId ?? 0;
    }

    if (userId <= 0) {
      return;
    }

    try {
      final dados = await DataService().fetchData(
        userId,
        'registros-glicose',
        false,
      );

      registrosGlicose = dados.registros;
       notifyListeners();
    } on DataException catch (e) {
      debugPrint(e.toString());
    }

    try {
      final dados2 = await DataService().fetchInsulinaData(userId);

      registrosInsulina = dados2.registros;

      notifyListeners();
    } on DataException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _glucoseImputController.dispose();
    _insulinaImputController.dispose();
    pararAlteracaoContinuaGlicose();
    pararAlteracaoContinuaInsulina();
    super.dispose();
  }
}
