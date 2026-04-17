import 'package:flutter/material.dart';
import 'package:insulog/states/home_screen_state.dart';
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
      setState(() {
        HomeScreenState().openScreen(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: MainBody(
        children: Column(
          children: [
            HomeHeaderWidget(size: size, state: homeScreenState),
            Expanded(child: HomeBodyWidget(size: size, state: homeScreenState,)),
          ],
        ),
      ),
    );
  }
}
