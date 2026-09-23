import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:insulog/states/report_state.dart';
import 'package:insulog/screens/clock_record_form_screen.dart';
import 'package:insulog/screens/report_export_screen.dart';
import 'package:insulog/widgets/app_shell.dart';
import 'package:insulog/screens/glucose_record_form_screen.dart';
import 'package:insulog/screens/login.dart';
import 'package:insulog/screens/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF3EA75F),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color.fromARGB(255, 255, 255, 255),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF3EA75F),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const AppShell(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => Register(),
        '/glucoseRecordForm': (context) => const GlucoseRecordFormScreen(),
        '/clock_register': (context) => const ClockRegisterScreen(),
        '/export_report': (context) {
          final state = ModalRoute.of(context)?.settings.arguments;
          if (state is! ReportState) {
            return Scaffold(
              appBar: AppBar(title: const Text('Exportar relatório')),
              body: const Center(
                child: Text(
                  'Volte e abra a exportação pela tela de relatório.',
                ),
              ),
            );
          }
          return ReportExportScreen(state: state);
        },
      },
    );
  }
}
