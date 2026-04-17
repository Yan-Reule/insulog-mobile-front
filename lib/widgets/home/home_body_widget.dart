import 'package:flutter/material.dart';
import 'package:insulog/states/home_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/home/glucose_record_list_widget.dart';

class HomeBodyWidget extends StatelessWidget {
  final Size size;
  final HomeScreenState state;

  HomeBodyWidget({super.key, required this.size, required this.state});

  final List<GlucoseRecord> _records = const [
    GlucoseRecord(
      time: '7:30',
      value: 110,
      mealLabel: 'Caf\u00e9',
      accentColor: Color(0xFF3EA75F),
    ),
    GlucoseRecord(
      time: '10:30',
      value: 90,
      mealLabel: 'Caf\u00e9',
      accentColor: Color(0xFF3EA75F),
    ),
    GlucoseRecord(
      time: '12:30',
      value: 50,
      mealLabel: 'Almo\u00e7o',
      accentColor: Color(0xFFE15A5A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 104, 104, 104),
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.width * 0.1),
          topRight: Radius.circular(size.width * 0.1),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomButtonWidget(
              onPressed: () => state.logout(context),
              text: 'Sair',
              textColor: Color.fromARGB(255, 255, 89, 89),
              textSize: size.width * 0.05,
            ),
            Container(
              margin: EdgeInsets.only(
                top: size.height * 0.02,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Registros recentes',
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Ter\u00e7a-feira, 17 de outubro',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.04,
                size.height * 0.03,
                size.width * 0.04,
                size.height * 0.035,
              ),
              child: GlucoseRecordListWidget(size: size, records: _records),
            ),
            
          ],
        ),
      ),
    );
  }
}
