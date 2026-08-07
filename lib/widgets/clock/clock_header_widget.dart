import 'package:flutter/material.dart'; 
import 'package:insulog/widgets/custom_button_widget.dart';

class ClockHeaderWidget extends StatelessWidget {
  final Size size;
   
  const ClockHeaderWidget({
    super.key,
    required this.size, 
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
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
                bgColor: Color.fromARGB(255, 255, 0, 0).withOpacity(0.2),
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
              
            ],
          ),
        ],
      ),
    );
  }
}
