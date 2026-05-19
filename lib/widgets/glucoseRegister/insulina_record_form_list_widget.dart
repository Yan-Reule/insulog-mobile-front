import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_registroInsulina.dart';
import 'package:insulog/states/glucose_record_form_screen_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';

class InsulinaRecordFormListWidget extends StatelessWidget {
  final Size size;
  final List<RegistroInsulina> records;
  final GlucoseRecordFormScreenState state;

  const InsulinaRecordFormListWidget({
    super.key,
    required this.size,
    required this.records,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.22,
      margin: EdgeInsets.only(bottom: size.height * 0.02),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            margin: EdgeInsets.only(
              top: size.height * 0.01,
              left: size.width * 0.03,
              bottom: size.height * 0.01,
            ),
            child: Text(
              'Valores recentes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          records.isEmpty
              ? SizedBox(
                  width: size.width,
                  height: size.height * 0.12,
                  child: Center(
                    child: Text(
                      'Sem registros recentes',
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        color: const Color(0xFF4C4C4C),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.005,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.height * 0.01,
                      childAspectRatio: 2.8,
                    ),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return _InsulinaRecordCard(
                        size: size,
                        record: record,
                        state: state,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class _InsulinaRecordCard extends StatelessWidget {
  final Size size;
  final RegistroInsulina record;
  final GlucoseRecordFormScreenState state;

  const _InsulinaRecordCard({
    required this.size,
    required this.record,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3EA75F)),
        borderRadius: BorderRadius.circular(size.width * 0.03),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${record.unidadeInsulina}',
                  style: TextStyle(
                    height: 0,
                    fontSize: size.width * 0.06,
                    color: const Color(0xFF171717),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'U',
                  style: TextStyle(
                    height: 0,
                    fontSize: size.width * 0.04,
                    color: const Color(0xFF4C4C4C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.17,
            height: size.height * 0.04,
            child: CustomButtonWidget(
              text: 'Usar',
              textColor: Color(0xFF3EA75F),
              onpressTextColor: Color.fromARGB(255, 255, 255, 255),
              border: Border.all(color: Color(0xFF3EA75F)),
              borderRadius: BorderRadius.circular(100),
              onpressBgColor: Color(0xFF3EA75F),
              onPressed: () => state.usarRegistroInsulina(record),
            ),
          ),
        ],
      ),
    );
  }
}
