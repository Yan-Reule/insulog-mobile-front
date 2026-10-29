import 'package:flutter/material.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/services/api/auth_service.dart';
import 'package:insulog/services/local/saved_login_service.dart';
import 'package:insulog/services/local/notification_settings_service.dart';

class OptionsState extends ChangeNotifier {
  OptionsState._();

  static final OptionsState instance = OptionsState._();

  factory OptionsState() => instance;

  Future<Map<String, dynamic>>? _doctorLinkFuture;
  bool _isLinking = false;

  Future<Map<String, dynamic>>? get doctorLinkFuture => _doctorLinkFuture;
  bool get isLinking => _isLinking;
  String get userName => Globals().username;
  String get userEmail => Globals().email;
  int get userId => Globals().userId;

  final _notificationSettings = NotificationSettingsService();

  bool get supportsNotificationSettings => _notificationSettings.isSupported;

  Future<void> openNotificationSettings(BuildContext context) async {
    final opened = await _notificationSettings.openSettings();
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível abrir as configurações de notificações.',
          ),
        ),
      );
    }
  }

  void iniciaTela() {
    _doctorLinkFuture = AuthService().getDoctorLink();
  }

  void refreshDoctorLink() {
    final doctorLinkFuture = AuthService().getDoctorLink();

    _doctorLinkFuture = doctorLinkFuture;
    notifyListeners();
  }

  Future<void> showLinkDialog(BuildContext context) async {
    if (_isLinking || !context.mounted) return;
    var enteredCode = '';
    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Vincular médico'),
        content: TextField(
          onChanged: (value) => enteredCode = value,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Código de vínculo',
            hintText: 'INSU-XXXXXXXX',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, enteredCode),
            child: const Text('Vincular'),
          ),
        ],
      ),
    );
    if (code == null || code.trim().isEmpty || !context.mounted) return;

    _isLinking = true;
    notifyListeners();
    try {
      await AuthService().redeemDoctorLink(code);
      if (!context.mounted) return;
      refreshDoctorLink();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Médico vinculado com sucesso.')),
      );
    } on AuthException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      _isLinking = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await SavedLoginService().clearCredentials();
    Globals().clearUsername();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
