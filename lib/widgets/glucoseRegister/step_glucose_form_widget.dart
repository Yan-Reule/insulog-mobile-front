import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/glucoseRegister/glucose_record_form_list_widget.dart';
import 'package:insulog/widgets/glucoseRegister/glucose_register_form_widget.dart';

class StepGlucoseFormWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;
  const StepGlucoseFormWidget({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      color: const Color(0xFFF2F2F2),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: GlucoseRegisterFormWidget(size: size, state: state),
              ),
            ],
          ),
          GlucoseRecordFormListWidget(
            size: size,
            records: state.registrosGlicose,
            state: state,
          ),
        ],
      ),
    );
  }
}
