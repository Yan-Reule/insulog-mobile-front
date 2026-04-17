import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/services/api/data_service.dart';
import 'package:insulog/services/local/saved_login_service.dart';

class HomeScreenState extends ChangeNotifier {
  HomeScreenState._();

  static final HomeScreenState instance = HomeScreenState._();

  factory HomeScreenState() => instance;

  final SavedLoginService _savedLoginService = SavedLoginService();
  late List<RegistroGlicose> registrosGlicose = [];

  String get mediaGlicose => calculateMedia();

  Future<void> openScreen(BuildContext context) async {
    final credenciais = await _savedLoginService.getCredentials();

    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: 'Login realizado com sucesso!',
      messageColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 66, 165, 69),
      duration: const Duration(seconds: 3),
    ).show(context);

    registrosGlicose =
        await DataService().fetchData(
              'registros-glicose/usuario',
              credenciais!.username,
            )
            as List<RegistroGlicose>;
  }

 String calculateMedia() {
  if (registrosGlicose.isEmpty) {
    return '0';
  }

  double mediaGlicose = 0;

  for (int i = 0; i < registrosGlicose.length; i++) {
    mediaGlicose += double.parse(registrosGlicose[i].nivelGlicose);
  }

  mediaGlicose = mediaGlicose / registrosGlicose.length;

  return mediaGlicose.toStringAsFixed(1);
}

  Future<void> logout(BuildContext context) async {
    await _savedLoginService.clearCredentials();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

}
