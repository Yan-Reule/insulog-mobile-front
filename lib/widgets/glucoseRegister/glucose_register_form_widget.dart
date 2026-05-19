import 'package:flutter/material.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';

class GlucoseRegisterFormWidget extends StatelessWidget {
  final Size size;
  final GlucoseRecordFormScreenState state;
  const GlucoseRegisterFormWidget({
    super.key,
    required this.size,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.18,
      margin: EdgeInsets.only(
        top: size.height * 0.03,
        bottom: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.05),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Glicose',
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.2,
                height: size.height * 0.08,
                child: CustomButtonWidget(
                  icon: Icons.remove,
                  iconColor: Color(0xFF3EA75F),
                  onpressIconColor: Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: Color(0xFF3EA75F)),
                  borderRadius: BorderRadius.circular(100),
                  onpressBgColor: Color(0xFF3EA75F),
                  onPressed: state.decrementarNivelGlicose,
                  onTapDown: state.iniciarDecrementoContinuoGlicose,
                  onTapUp: state.pararAlteracaoContinuaGlicose,
                  onTapCancel: state.pararAlteracaoContinuaGlicose,
                ),
              ),
              SizedBox(
                width: size.width * 0.2,
                child: TextField(
                  maxLines: 1,
                  maxLength: 3,
                  controller: state.glucoseImputController,
                  keyboardType: TextInputType.number,
                  onChanged: state.atualizarNivelGlicose,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    counterText: '',
                    hintText: '0',
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.2,
                height: size.height * 0.08,
                child: CustomButtonWidget(
                  icon: Icons.add,
                  iconColor: Color(0xFF3EA75F),
                  onpressIconColor: Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: Color(0xFF3EA75F)),
                  borderRadius: BorderRadius.circular(100),
                  onpressBgColor: Color(0xFF3EA75F),
                  onPressed: state.incrementarNivelGlicose,
                  onTapDown: state.iniciarIncrementoContinuoGlicose,
                  onTapUp: state.pararAlteracaoContinuaGlicose,
                  onTapCancel: state.pararAlteracaoContinuaGlicose,
                ),
              ),
            ],
          ),
          Text(
            'INFORME O NIVEL DE GLICOSE ATUAL',
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 170, 170, 170),
            ),
          ),
        ],
      ),
    );
  }
}
