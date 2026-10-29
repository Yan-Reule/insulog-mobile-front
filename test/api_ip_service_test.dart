import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/services/local/api_ip_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiIpService', () {
    test('uses hosted API by default for a new installation', () async {
      SharedPreferences.setMockInitialValues({});
      final service = ApiIpService();

      expect(await service.getConnectionMode(), ApiConnectionMode.hosted);
      expect(
        await service.getBaseUrl(),
        'https://insulog-back-supa.onrender.com',
      );
    });

    test(
      'preserves a saved local IP for installations without a mode',
      () async {
        SharedPreferences.setMockInitialValues({
          'api_ip_digits': '192.168.1.100',
        });
        final service = ApiIpService();

        expect(await service.getConnectionMode(), ApiConnectionMode.local);
        expect(await service.getBaseUrl(), 'http://192.168.1.100:3000');
      },
    );

    test(
      'switches modes dynamically without replacing the saved local IP',
      () async {
        SharedPreferences.setMockInitialValues({
          'api_ip_digits': '192.168.1.100',
        });
        final service = ApiIpService();
        await service.saveConnectionMode(ApiConnectionMode.hosted);

        expect(await service.getBaseUrl(), ApiIpService.hostedApiBaseUrl);
        expect(await service.getApiIpDigits(), '192.168.1.100');

        await service.saveConnectionMode(ApiConnectionMode.local);
        expect(await service.getBaseUrl(), 'http://192.168.1.100:3000');
      },
    );
  });
}
