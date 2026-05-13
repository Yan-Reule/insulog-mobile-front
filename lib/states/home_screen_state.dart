import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/services/api/data_service.dart';
import 'package:insulog/services/local/saved_login_service.dart';

class HomeScreenState extends ChangeNotifier {
  HomeScreenState._();

  static final HomeScreenState instance = HomeScreenState._();

  factory HomeScreenState() => instance;

  final SavedLoginService _savedLoginService = SavedLoginService();
  late List<RegistroGlicose> registrosGlicose = [];

  bool isListOpen = false;
  bool get isListOp => isListOpen;
  List<RegistroGlicose> get visibleRecords => returnList();
  String mediaGlicose = '';
  String statusMediaDiariaDescricao = '';
  int _statusMedia = 3;
  int colorStatusMedia = 0xfffefefe;

  int get statusMedia => _statusMedia;

  List<RegistroGlicose> returnList() {
    if (isListOpen) {
      return registrosGlicose;
    }

    return registrosGlicose.take(4).toList();
  }

  void setListOpen(bool isOpen) {
    isListOpen = isOpen;
  }

  Future<void> openScreen(BuildContext context) async {
    final credenciais = await _savedLoginService.getCredentials();

    if (credenciais != null) {
      Globals().setUserId(credenciais.userId);
      Globals().setUsername(credenciais.username);
    }

    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: 'Login realizado com sucesso!',
      messageColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 66, 165, 69),
      duration: const Duration(seconds: 3),
    ).show(context);

    await refreshRecords();
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
      final dados = await DataService().fetchData(userId);

      registrosGlicose = dados.registros;
      mediaGlicose = dados.mediaDiaria.toString();
      statusMediaDiariaDescricao = dados.statusMediaDiariaDescricao;
      _statusMedia = dados.statusMediaDiaria;

      switch (_statusMedia) {
        case 0:
          colorStatusMedia = 0xFFFFC81e;
          break;
        case 1:
          colorStatusMedia = 0xFF3ea75f;
          break;
        case 2:
          colorStatusMedia = 0xFFD62828;
          break;
        default:
          colorStatusMedia = 0xFF808080;
          break;
      }

      notifyListeners();
    } on DataException catch (e) {
      debugPrint(e.toString());
    }
  }

  String returnNameLogin() {
    return Globals().username;
  }

  String returnFirstNameCaractere() {
    final username = Globals().username.trim();

    if (username.isEmpty) {
      return '';
    }

    return username[0].toUpperCase();
  }

  String returnCurrentDateLabel() {
    const weekDays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    final now = DateTime.now();
    final weekDay = weekDays[now.weekday - 1];
    final month = months[now.month - 1];

    return '$weekDay, ${now.day} de $month';
  }

  void showMoreRecords() {
    if (isListOpen) {
      return;
    }

    setListOpen(true);

    notifyListeners();
  }

  void showLessRecords() {
    if (!isListOpen) {
      return;
    }

    setListOpen(false);
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _savedLoginService.clearCredentials();
    Globals().clearUsername();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
