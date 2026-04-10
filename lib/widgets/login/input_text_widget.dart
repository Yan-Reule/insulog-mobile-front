import 'package:flutter/material.dart';
import 'package:insulog/states/login_form_state.dart';

class InputTextWidget extends StatelessWidget {
  final LoginFormState loginFormState;
  final String label;
  final String placeholder;
  final bool isPassword;
  final Size size;
  final Widget? error;
  final TextEditingController controller;

  const InputTextWidget({
    super.key,
    required this.loginFormState,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.isPassword,
    required this.size,
      this.error,
  });
 


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: size.height * 0.02,
        left: size.width * 0.1,
        right: size.width * 0.1,
      ),
      child: TextField(
        controller: controller, 
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          error: error,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(size.width * 0.035)),
          ),
          border:   OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(size.width * 0.035)),
          ),
        ),
      ),
    );
  }
}
