import 'package:flutter/material.dart';
import 'package:insulog/widgets/container_card_widget.dart';

class OptionsLanguageWidget extends StatelessWidget {
  const OptionsLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2FAE94);

    return ContainerCardWidget(
      size: MediaQuery.sizeOf(context),
      widthFactor: 0.9,
      isMarginTop: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'IDIOMA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF505050),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: const Color(0xFFD3D3D3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇧🇷', semanticsLabel: 'Brasil'),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Português',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF171717),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: Color(0xFF505050),
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
    );
  }
}
