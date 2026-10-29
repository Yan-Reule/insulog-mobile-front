import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/states/options_state.dart';
import 'package:insulog/widgets/options/options_notifications_widget.dart';

void main() {
  const channel = MethodChannel('insulog/settings');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('notificacoes abre as configuracoes pelo canal nativo', (
    tester,
  ) async {
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call.method);
      return true;
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: OptionsNotificationsWidget(state: OptionsState())),
      ),
    );
    await tester.tap(find.text('Notificações'));
    await tester.pumpAndSettle();
    expect(calls, ['openNotificationSettings']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('informa quando o Android nao consegue abrir as configuracoes', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      _,
    ) async {
      throw PlatformException(code: 'SETTINGS_UNAVAILABLE');
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: OptionsNotificationsWidget(state: OptionsState())),
      ),
    );
    await tester.tap(find.text('Notificações'));
    await tester.pumpAndSettle();
    expect(
      find.text('Não foi possível abrir as configurações de notificações.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
