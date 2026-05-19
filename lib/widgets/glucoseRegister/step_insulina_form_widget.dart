import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart'; 
import 'package:insulog/widgets/glucoseRegister/insulina_record_form_list_widget.dart';
import 'package:insulog/widgets/glucoseRegister/insulina_register_form_widget.dart';
import 'package:insulog/widgets/glucoseRegister/tipo_insulina_card_widget.dart';

class StepInsulinaFormWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;
  const StepInsulinaFormWidget({
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
                child: InsulinaRegisterFormWidget(size: size, state: state),
              ),
            ],
          ),
          InsulinaRecordFormListWidget(
            size: size,
            records: state.registrosInsulina,
            state: state,
          ),
          TipoInsulinaCardWidget(size: size, state: state),
        ],
      ),
    );
  }
}
