import 'package:flutter/material.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';

class GlucoseRecordListWidget extends StatelessWidget {
  final Size size;
  final List<RegistroGlicose> records;
  final VoidCallback? onShowMore;
  final VoidCallback? onShowLess;

  const GlucoseRecordListWidget({
    super.key,
    required this.size,
    required this.records,
    this.onShowMore,
    this.onShowLess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...records.map(
          (record) => Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.022),
            child: _GlucoseRecordCard(size: size, record: record),
          ),
        ),
        if (onShowMore != null || onShowLess != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onShowLess != null)
                GestureDetector(
                  onTap: onShowLess,
                  child: Text(
                    'Ver menos',
                    style: TextStyle(
                      color: const Color(0xFF6B6B6B),
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              if (onShowMore != null && onShowLess != null)
                SizedBox(width: size.width * 0.06),
              if (onShowMore != null)
                GestureDetector(
                  onTap: onShowMore,
                  child: Text(
                    'Mostrar mais',
                    style: TextStyle(
                      color: const Color(0xFF3EA75F),
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF3EA75F),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _GlucoseRecordCard extends StatelessWidget {
  final Size size;
  final RegistroGlicose record;

  const _GlucoseRecordCard({required this.size, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.045,
        vertical: size.height * 0.022,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.05),
        border: Border(
          bottom: BorderSide(color: Color(record.colorStatus), width: 4)
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 104, 104, 104),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: size.width * 0.045,
            height: size.width * 0.045,
            decoration: BoxDecoration(
              color: Color(record.colorStatus),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: size.width * 0.025),
          SizedBox(
            width: size.width * 0.2,
            child: Text(
              record.horaFormatada,
              style: TextStyle(
                fontSize: size.width * 0.055,
                color: const Color(0xFF4C4C4C),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${record.nivelGlicose}',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      color: const Color(0xFF171717),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' mg/dL',
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      color: const Color(0xFF4C4C4C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: size.width * 0.02),
          Text(
            record.periodo,
            style: TextStyle(
              fontSize: size.width * 0.055,
              color: const Color(0xFF7C7C7C),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
