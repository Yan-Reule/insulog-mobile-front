import 'package:flutter/material.dart';
import 'package:insulog/states/options_state.dart';

class OptionsHeaderWidget extends StatelessWidget {
  final Size size;
  final OptionsState optionsState;

  const OptionsHeaderWidget({
    super.key,
    required this.size,
    required this.optionsState,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3EA75F);
    const titleColor = Color(0xFF171717);
    const secondaryColor = Color(0xFF6B6B6B);

    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.25),
      padding: EdgeInsets.fromLTRB(
        size.width * 0.06,
        size.height * 0.025,
        size.width * 0.06,
        0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // SizedBox(width: size.width * 0.035),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: primaryColor,
                        size: 27,
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),

                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Opções',
                            style: TextStyle(
                              fontSize: 28,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: titleColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configurações do aplicativo',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: size.height * 0.022),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: primaryColor.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: size.height * 0.022),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withValues(alpha: 0.18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: primaryColor.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.person_outline,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        optionsState.userName.isNotEmpty
                            ? optionsState.userName
                            : 'Nome não informado',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        optionsState.userId > 0
                            ? 'ID: ${optionsState.userId}'
                            : 'ID não informado',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
