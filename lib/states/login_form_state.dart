import 'package:flutter/material.dart';

class LoginFormState extends ChangeNotifier {
  LoginFormState._() {
    usernameController.addListener(_validateUsername);
    passwordController.addListener(_validatePassword);
  }

  static final LoginFormState instance = LoginFormState._();

  factory LoginFormState() => instance;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get username => usernameController.text;
  String get password => passwordController.text;

  bool isClicked = false;

  Widget? usernameError;
  Widget? passwordError;

  void logar() {
    isClicked = true;
    _validateUsername();
    _validatePassword();
  }

  void _validateUsername() {
    if (username.isEmpty && !isClicked) {
      usernameError = null; // Não exibe erro se o botão não foi clicado
    } else if (username.isEmpty && isClicked) {
      usernameError = const Text(
        'Campo obrigatório',
        style: TextStyle(color: Colors.red),
      );
    } else if (username.length < 3) {
      usernameError = const Text(
        'O nome deve ter pelo menos 3 caracteres',
        style: TextStyle(color: Colors.red),
      );
    } else {
      usernameError = null;
    }
    notifyListeners();
  }

  void _validatePassword() {
    if (password.isEmpty && !isClicked) {
      passwordError = null; // Não exibe erro se o botão não foi clicado
    } else if (password.isEmpty && isClicked) {
      passwordError = const Text(
        'Campo obrigatório',
        style: TextStyle(color: Colors.red),
      );
    } else if (password.length < 6) {
      passwordError = const Text(
        'A senha deve ter pelo menos 6 caracteres',
        style: TextStyle(color: Colors.red),
      );
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  void clear() {
    usernameController.clear();
    passwordController.clear();
  }
}
