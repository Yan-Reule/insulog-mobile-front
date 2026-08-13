import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_form_registroGlicose.dart';
import 'package:insulog/states/clock_state.dart';
import 'package:insulog/widgets/clock/clock_header_widget.dart';
import 'package:insulog/widgets/clock/clock_register_header_widget.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/custom_container_widget.dart';
import 'package:insulog/widgets/glucoseRegister/glucose_header_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_confirm_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_glucose_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_insulina_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/step_period_form_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class ClockRegisterScreen extends StatefulWidget {
  const ClockRegisterScreen({super.key});

  @override
  State<ClockRegisterScreen> createState() => _ClockRegisterScreenState();
}

class ClockRegisterFormEditArgs {
  final int idRegistro;
  final NewRegistroGlicose registro;

  const ClockRegisterFormEditArgs({
    required this.idRegistro,
    required this.registro,
  });
}

class _ClockRegisterScreenState extends State<ClockRegisterScreen> {
  final stateClock = ClockState();
  // bool _loadedRouteArgs = false;

  @override
  void initState() {
    super.initState();
    stateClock.addListener(handleNotify);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateClock.refreshClockRecords();
    });
  }

  void handleNotify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    stateClock.removeListener(handleNotify);
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (_loadedRouteArgs) {
  //     return;
  //   }

  //   _loadedRouteArgs = true;
  //   final args = ModalRoute.of(context)?.settings.arguments;

  //   if (args is GlucoseRecordFormEditArgs) {
  //     stateClock.iniciarEdicao(args.idRegistro, args.registro);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: size.width * 0.4,
            height: size.height * 0.06,
            margin: const EdgeInsets.only(bottom: 15),
            child: CustomButtonWidget(
              text: 'Salvar',
              textSize: size.height * 0.025,
              isFontBold: true,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              selected: false,
              icon: Icons.save,
              iconColor: Color.fromARGB(255, 255, 255, 255),
              onpressIconColor: Color.fromARGB(255, 98, 98, 98),
              textColor: Color.fromARGB(255, 255, 255, 255),
              onpressTextColor: Color.fromARGB(255, 255, 255, 255),
              bgColor: Color(0xFF3EA75F),
              onpressBgColor: Color.fromARGB(255, 158, 158, 158),

              onPressed: () => (context),
              boxShadow: BoxShadow(
                color: Color.fromARGB(80, 0, 0, 0),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ),
          ),
        ],
      ),
      body: 
      
      MainBody(
        children: Column(
          children: [
            ClockRegisterHeaderWidget(size: size, state: stateClock),

            Expanded(
              child: CustomContainerWidget(
                width: size.width,
                innerShadow: const InnerShadow(
                  color: Color.fromARGB(80, 0, 0, 0),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.1),
                    topRight: Radius.circular(size.width * 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
