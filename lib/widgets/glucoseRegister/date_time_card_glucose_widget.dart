
import 'package:flutter/material.dart';

class DateTimeCard extends StatelessWidget {
  final Size size;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const DateTimeCard({
    required this.size,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(size.width * 0.05),
      onTap: onTap,
      child: Container(
        height: size.height * 0.2,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF3EA75F),
              size: size.width * 0.08,
            ),
            SizedBox(height: size.height * 0.015),
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF3EA75F),
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
