import 'package:flutter/material.dart';

class GlucoseRecord {
  final String time;
  final int value;
  final String mealLabel;
  final Color accentColor;

  const GlucoseRecord({
    required this.time,
    required this.value,
    required this.mealLabel,
    required this.accentColor,
  });
}

class GlucoseRecordListWidget extends StatelessWidget {
  final Size size;
  final List<GlucoseRecord> records;
  final VoidCallback? onShowMore;

  const GlucoseRecordListWidget({
    super.key,
    required this.size,
    required this.records,
    this.onShowMore,
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
    );
  }
}

class _GlucoseRecordCard extends StatelessWidget {
  final Size size;
  final GlucoseRecord record;

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
        border: Border.all(color: const Color(0xFFD8D3CE)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(18, 0, 0, 0),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -size.width * 0.045,
            right: -size.width * 0.045,
            bottom: -size.height * 0.022,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: record.accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(size.width * 0.05),
                  bottomRight: Radius.circular(size.width * 0.05),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: size.width * 0.045,
                height: size.width * 0.045,
                decoration: BoxDecoration(
                  color: record.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: size.width * 0.025),
              SizedBox(
                width: size.width * 0.16,
                child: Text(
                  record.time,
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
                        text: '${record.value}',
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
                record.mealLabel,
                style: TextStyle(
                  fontSize: size.width * 0.055,
                  color: const Color(0xFF7C7C7C),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
