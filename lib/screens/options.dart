import 'package:flutter/material.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainBody(children: Center(child: Text('Opções (em construção)'))),
    );
  }
}
