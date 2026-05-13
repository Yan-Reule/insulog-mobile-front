import 'package:flutter/material.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/custom_container_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class GlucoseRecordFormScreen extends StatefulWidget {
  const GlucoseRecordFormScreen({super.key});

  @override
  State<GlucoseRecordFormScreen> createState() =>
      _GlucoseRecordFormScreenState();
}

class _GlucoseRecordFormScreenState extends State<GlucoseRecordFormScreen> {
  final _controller = PageController();
  int step = 0;

  void next() {
    if (step < 3) {
      setState(() => step++);
      _controller.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void back() {
    if (step > 0) {
      setState(() => step--);
      _controller.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: size.width * 0.4,
            height: size.height * 0.06,
            margin: const EdgeInsets.only(bottom: 15),
            child: CustomButtonWidget(
              text: 'Voltar',
              textSize: size.height * 0.025,
              isFontBold: step == 0 ? false : true,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              selected: step == 0,
              textColor: Color.fromARGB(255, 255, 255, 255),
              onpressTextColor: step == 0
                  ? Color.fromARGB(255, 98, 98, 98)
                  : Color.fromARGB(255, 255, 255, 255),
              bgColor: Color(0xFF3EA75F),
              onpressBgColor: Color.fromARGB(255, 158, 158, 158),
              onPressed: step == 0 ? null : back,
              boxShadow: step == 0
                  ? null
                  : BoxShadow(
                      color: Color.fromARGB(255, 158, 158, 158),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
            ),
          ),
          Container(
            width: size.width * 0.4,
            height: size.height * 0.06,
            margin: const EdgeInsets.only(bottom: 15),
            child: CustomButtonWidget(
              text: 'Avançar',
              textSize: size.height * 0.025,
              isFontBold: step == 3 ? false : true,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              selected: step == 3,

              textColor: Color.fromARGB(255, 255, 255, 255),
              onpressTextColor: step == 3
                  ? Color.fromARGB(255, 98, 98, 98)
                  : Color.fromARGB(255, 255, 255, 255),
              bgColor: Color(0xFF3EA75F),
              onpressBgColor: Color.fromARGB(255, 158, 158, 158),

              onPressed: step == 3 ? null : next,
              boxShadow: step == 3
                  ? null
                  : BoxShadow(
                      color: Color.fromARGB(255, 158, 158, 158),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
            ),
          ),
        ],
      ),
      body: MainBody(
        children: Column(
          children: [
            SizedBox(
              height: size.height * 0.2,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: SizedBox(
                      width: size.width * 0.15,
                      child: CustomButtonWidget(
                        isFontBold: true,
                        inversePosition: true,
                        textSize: size.height * 0.025,
                        textColor: Color.fromARGB(255, 255, 0, 0),
                        icon: Icons.close,
                        iconColor: Color.fromARGB(255, 255, 0, 0),
                        iconSize: size.height * 0.035,
                        onPressed: () => Navigator.pop(context),
                        bgColor: Color.fromARGB(
                          255,
                          255,
                          0,
                          0,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          // child:
                          // ShaderMask(
                          //   shaderCallback: (bounds) => LinearGradient(
                          //     colors: [Color(0xFF65ff95), Color(0xFF3ea75f)],
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //   ).createShader(bounds),
                          child: Text(
                            "Novo Registro",
                            style: TextStyle(
                              fontSize: size.height * 0.045,
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                            // ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  AnimatedContainer(
                                    width: step == 0
                                        ? size.width * 0.3
                                        : size.width * 0.18,
                                    height: size.height * 0.005,
                                    color: const Color(0xFF3EA75F),
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  AnimatedScale(
                                    scale: step == 0 ? 1.3 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      "Glicose",
                                      style: TextStyle(
                                        fontWeight: step == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: [
                                  AnimatedContainer(
                                    width: step == 1
                                        ? size.width * 0.3
                                        : size.width * 0.18,
                                    height: size.height * 0.005,
                                    color: const Color(0xFF3EA75F),
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  AnimatedScale(
                                    scale: step == 1 ? 1.3 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      "Periodo",
                                      style: TextStyle(
                                        fontWeight: step == 1
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: [
                                  AnimatedContainer(
                                    width: step == 2
                                        ? size.width * 0.3
                                        : size.width * 0.18,
                                    height: size.height * 0.005,
                                    color: const Color(0xFF3EA75F),
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  AnimatedScale(
                                    scale: step == 2 ? 1.3 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      "Insulina",
                                      style: TextStyle(
                                        fontWeight: step == 2
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  AnimatedContainer(
                                    width: step == 3
                                        ? size.width * 0.3
                                        : size.width * 0.18,
                                    height: size.height * 0.005,
                                    color: const Color(0xFF3EA75F),
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  AnimatedScale(
                                    scale: step == 3 ? 1.3 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      "Confirmar",
                                      style: TextStyle(
                                        fontWeight: step == 3
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomContainerWidget(
                width: size.width,
                innerShadow: const InnerShadow(
                  color: Color.fromARGB(255, 104, 104, 104),
                  blurRadius: 4,
                  spreadRadius: 1,
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
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        physics:
                            const NeverScrollableScrollPhysics(), // só pelos botões
                        children: const [
                          Center(child: Text('Etapa 1')),
                          Center(child: Text('Etapa 2')),
                          Center(child: Text('Etapa 3')),
                          Center(child: Text('Etapa 4')),
                        ],
                      ),
                    ),
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
