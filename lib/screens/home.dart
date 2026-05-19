import 'package:flutter/material.dart';
import 'package:insulog/states/home_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/home/home_body_widget.dart';
import 'package:insulog/widgets/home/home_header_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeScreenState homeScreenState = HomeScreenState();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeScreenState.openScreen(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: SizedBox(
        width: size.width * 0.4,
        height: size.height * 0.08,
        child: CustomButtonWidget(
          onPressed: () => Navigator.pushNamed(context, '/glucoseRecordForm'),
          text: "Novo Registro",
          isFontBold: true,
          icon: Icons.add,
          textColor: Color.fromARGB(255, 255, 255, 255),
          onpressTextColor: Color.fromARGB(255, 255, 255, 255),
          bgColor: Color(0xFF3EA75F),
          onpressBgColor: Color.fromARGB(255, 31, 88, 49),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            blurRadius: 2,
        offset: Offset(0, 2),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: AnimatedBuilder(
        animation: homeScreenState,
        builder: (context, _) => MainBody(
          children: Column(
            children: [
              HomeHeaderWidget(size: size, state: homeScreenState),
              Expanded(
                child: HomeBodyWidget(size: size, state: homeScreenState),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
