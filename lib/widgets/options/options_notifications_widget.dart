import 'package:flutter/material.dart';
import 'package:insulog/states/options_state.dart';
import 'package:insulog/widgets/container_card_widget.dart';

class OptionsNotificationsWidget extends StatelessWidget {
  final OptionsState state;

  const OptionsNotificationsWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final borderRadius = BorderRadius.circular(size.width * 0.05);
    return ContainerCardWidget(
      size: size,
      widthFactor: 0.9,
      isMarginTop: false,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3EA75F).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF3EA75F),
            ),
          ),
          title: const Text(
            'Notificações',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Configurar no Android'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => state.openNotificationSettings(context),
        ),
      ),
    );
  }
}
