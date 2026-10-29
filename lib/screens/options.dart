import 'package:flutter/material.dart';
import 'package:insulog/states/options_state.dart';
import 'package:insulog/widgets/custom_container_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';
import 'package:insulog/widgets/options/options_doctor_link_widget.dart';
import 'package:insulog/widgets/options/options_header_widget.dart';
import 'package:insulog/widgets/options/options_notifications_widget.dart';
import 'package:insulog/widgets/options/options_language_widget.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  final OptionsState optionsState = OptionsState();

  @override
  void initState() {
    super.initState();
    optionsState.iniciaTela();
    optionsState.addListener(handleNotify);
  }

  void handleNotify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    optionsState.removeListener(handleNotify);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: MainBody(
        children: Column(
          children: [
            OptionsHeaderWidget(size: size, optionsState: optionsState),

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
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [ 
                      SizedBox(height: size.height * 0.02), 
                      if (optionsState.supportsNotificationSettings)
                        OptionsNotificationsWidget(state: optionsState),
                      const OptionsLanguageWidget(),
                      OptionsDoctorLinkWidget(state: optionsState), 
                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () => optionsState.logout(context),
                          icon: const Icon(Icons.logout),
                          label: const Text('Sair'),
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
