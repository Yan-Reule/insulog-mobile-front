import 'package:flutter/material.dart';
import 'package:insulog/states/login_form_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/login/input_Text_Widget.dart';

class Loginform extends StatefulWidget {
  final LoginFormState loginFormState;
  final Size size;

  const Loginform({
    super.key,
    required this.size,
    required this.loginFormState,
  });

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  @override
  void initState() {
    super.initState();
    widget.loginFormState.addListener(handleNotify);
  }

  void handleNotify() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.loginFormState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            InputTextWidget(
              size: widget.size,
              label: 'Usuario',
              controller: widget.loginFormState.usernameController,
              placeholder: 'Nome de Usuario',
              isPassword: false,
              error: widget.loginFormState.usernameError,
              loginFormState: widget.loginFormState,
            ),
            InputTextWidget(
              size: widget.size,
              label: 'Senha',
              controller: widget.loginFormState.passwordController,
              placeholder: 'Digite sua senha',
              isPassword: true,
              error: widget.loginFormState.passwordError,
              loginFormState: widget.loginFormState,
            ),
            Center(
              child: Text(
                'Esqueci minha senha',
                style: TextStyle(
                  color: const Color(0xFF3EA75F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: widget.size.height * 0.02,
                left: widget.size.width * 0.1,
                right: widget.size.width * 0.1,
              ),
              height: widget.size.height * 0.06,
              child: CustomButtonWidget(
                onPressed: () => widget.loginFormState.logar(),
                text: "Entrar",
                isFontBold: true,
                textSize: widget.size.height * 0.025,
                textColor: Colors.white,
                onpressTextColor: Colors.grey[600]!,
                onpressBoxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
                boxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
                colorGradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 71, 204, 113),
                    const Color(0xFF3EA75F),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onpressColorGradient: LinearGradient(
                  colors: [const Color(0xFF3EA75F), const Color(0xFF3EA75F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(200)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: widget.size.height * 0.02,
                left: widget.size.width * 0.1,
                right: widget.size.width * 0.1,
              ),
              height: widget.size.height * 0.06,
              child: CustomButtonWidget(
                text: "Cadastrar",
                isFontBold: true,
                textSize: widget.size.height * 0.025,
                textColor: const Color(0xFF3EA75F),
                onpressTextColor: const Color(0xFF3EA75F),
                onpressBoxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),

                border: Border.all(color: const Color(0xFF3EA75F), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(200)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
