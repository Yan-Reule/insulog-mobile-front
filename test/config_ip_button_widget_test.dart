import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/services/local/api_ip_service.dart';
import 'package:insulog/widgets/config_ip_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('selects API mode and retains local IP while hosted is active', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ConfigIpButtonWidget())),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('API Hospedada'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(
      tester
          .widgetList<RadioListTile<ApiConnectionMode>>(
            find.byType(RadioListTile<ApiConnectionMode>),
          )
          .first
          .groupValue,
      ApiConnectionMode.hosted,
    );

    await tester.tap(find.text('API Local'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '192.168.1.100');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('api_ip_digits'), '192.168.1.100');
    expect(preferences.getString('api_connection_mode'), 'local');

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('API Hospedada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(preferences.getString('api_connection_mode'), 'hosted');
    expect(preferences.getString('api_ip_digits'), '192.168.1.100');
  });
}
