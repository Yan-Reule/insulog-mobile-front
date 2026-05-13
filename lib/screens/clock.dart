
import 'package:flutter/material.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainBody(children: Center(child: Text('Lembrete (em construção)'))),
    );
  }
}