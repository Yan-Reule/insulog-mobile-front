import 'package:flutter/material.dart';
import 'package:insulog/states/options_state.dart';
import 'package:insulog/widgets/container_card_widget.dart';

class OptionsDoctorLinkWidget extends StatelessWidget {
  final OptionsState state;

  const OptionsDoctorLinkWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ContainerCardWidget(
      size: MediaQuery.sizeOf(context),
      widthFactor: 0.9,
      isMarginTop: false,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: FutureBuilder<Map<String, dynamic>>(
          future: state.doctorLinkFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vínculo com médico',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString()),
                  TextButton.icon(
                    onPressed: state.refreshDoctorLink,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              );
            }

            final link = snapshot.data ?? const <String, dynamic>{};
            final doctor = link['medico'] is Map<String, dynamic>
                ? link['medico'] as Map<String, dynamic>
                : null;
            if (doctor != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Médico vinculado',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doctor['nome']?.toString() ?? 'Médico',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (doctor['email'] != null) Text(doctor['email'].toString()),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vincular médico',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Você pode usar o Insulog sem vínculo. Se recebeu um código do médico, informe-o aqui.',
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: state.isLinking
                        ? null
                        : () => state.showLinkDialog(context),
                    icon: state.isLinking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.link),
                    label: Text(
                      state.isLinking ? 'Vinculando...' : 'Inserir código',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3EA75F),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
