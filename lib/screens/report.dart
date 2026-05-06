import 'package:flutter/material.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainBody(children: Center(child: Text('Relatório (em construção)'))),
    );
  }
}