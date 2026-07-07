import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insulog/services/local/api_ip_service.dart';

class ConfigIpButtonWidget extends StatelessWidget {
  const ConfigIpButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showConfigIpDialog(context),
      tooltip: 'Configurar IP',
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.08),
        foregroundColor: Colors.black.withOpacity(0.35),
        hoverColor: Colors.black.withOpacity(0.12),
        highlightColor: Colors.black.withOpacity(0.10),
      ),
      icon: const Icon(Icons.settings),
    );
  }

  Future<void> _showConfigIpDialog(BuildContext context) async {
    final apiIpService = ApiIpService();
    final savedDigits = await apiIpService.getApiIpDigits();

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => _ConfigIpDialog(
        apiIpService: apiIpService,
        initialDigits: savedDigits,
      ),
    );
  }
}

class _ConfigIpDialog extends StatefulWidget {
  final ApiIpService apiIpService;
  final String initialDigits;

  const _ConfigIpDialog({
    required this.apiIpService,
    required this.initialDigits,
  });

  @override
  State<_ConfigIpDialog> createState() => _ConfigIpDialogState();
}

class _ConfigIpDialogState extends State<_ConfigIpDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text:
          ApiIpService.formatDigitsAsIp(widget.initialDigits) ??
          widget.initialDigits,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configuracao de IP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Digite os numeros do IP. Os pontos aparecem automaticamente.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: const [_IpAddressInputFormatter()],
            decoration: InputDecoration(
              labelText: 'IP da API',
              hintText: 'Ex: 10.173.57.47',
              errorText: _errorMessage,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              if (_errorMessage == null) {
                return;
              }

              setState(() {
                _errorMessage = null;
              });
            },
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final digits = _onlyDigits(value.text);
              final previewIp = ApiIpService.formatDigitsAsIp(digits);

              return Text(
                previewIp == null
                    ? 'Exemplo: 101735747 = 10.173.57.47'
                    : 'Rota: http://$previewIp:3000',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.55),
                  fontSize: 12,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _saveIp, child: const Text('Salvar')),
      ],
    );
  }

  Future<void> _saveIp() async {
    final digits = _onlyDigits(_controller.text);
    final ip = ApiIpService.formatDigitsAsIp(digits);

    if (ip == null) {
      setState(() {
        _errorMessage = 'Digite um IP valido usando apenas numeros.';
      });
      return;
    }

    await widget.apiIpService.saveApiIpDigits(digits);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  static String _onlyDigits(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }
}

class _IpAddressInputFormatter extends TextInputFormatter {
  const _IpAddressInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 12 ? digits.substring(0, 12) : digits;
    final formattedText = _formatIp(limitedDigits);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  static String _formatIp(String digits) {
    if (digits.isEmpty) {
      return '';
    }

    final formattedIp = ApiIpService.formatDigitsAsIp(digits);
    if (formattedIp != null) {
      return formattedIp;
    }

    final octets = <String>[];
    for (var index = 0; index < digits.length; index += 3) {
      final end = index + 3 > digits.length ? digits.length : index + 3;
      octets.add(digits.substring(index, end));
    }

    return octets.join('.');
  }
}
