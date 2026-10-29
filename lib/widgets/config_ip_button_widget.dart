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
    final savedDigitsFuture = apiIpService.getApiIpDigits();
    final savedModeFuture = apiIpService.getConnectionMode();
    final savedDigits = await savedDigitsFuture;
    final savedMode = await savedModeFuture;

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => _ConfigIpDialog(
        apiIpService: apiIpService,
        initialDigits: savedDigits,
        initialMode: savedMode,
      ),
    );
  }
}

class _ConfigIpDialog extends StatefulWidget {
  final ApiIpService apiIpService;
  final String initialDigits;
  final ApiConnectionMode initialMode;

  const _ConfigIpDialog({
    required this.apiIpService,
    required this.initialDigits,
    required this.initialMode,
  });

  @override
  State<_ConfigIpDialog> createState() => _ConfigIpDialogState();
}

class _ConfigIpDialogState extends State<_ConfigIpDialog> {
  late final TextEditingController _controller;
  late ApiConnectionMode _selectedMode;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ApiIpService.isValidIp(widget.initialDigits)
          ? widget.initialDigits
          : ApiIpService.formatDigitsAsIp(widget.initialDigits) ??
                widget.initialDigits,
    );
    _selectedMode = widget.initialMode;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configuração da API'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModeOption(
            mode: ApiConnectionMode.hosted,
            title: 'API Hospedada',
            subtitle: 'Render',
          ),
          _buildModeOption(
            mode: ApiConnectionMode.local,
            title: 'API Local',
            subtitle: 'Conectar a um servidor na rede local',
          ),
          if (_selectedMode == ApiConnectionMode.local) ...[
            const SizedBox(height: 12),
            const Text('Digite o endereço IP completo, incluindo os pontos.'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                LengthLimitingTextInputFormatter(15),
              ],
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
                final ip = value.text.trim();

                return Text(
                  ApiIpService.isValidIp(ip)
                      ? 'Rota: http://$ip:3000'
                      : 'Exemplo: 192.168.31.41',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.55),
                    fontSize: 12,
                  ),
                );
              },
            ),
          ],
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

  Widget _buildModeOption({
    required ApiConnectionMode mode,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedMode == mode;

    return Material(
      color: isSelected
          ? const Color(0xFF3EA75F).withOpacity(0.08)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? const Color(0xFF3EA75F) : Colors.black12,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: RadioListTile<ApiConnectionMode>(
        value: mode,
        groupValue: _selectedMode,
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            _selectedMode = value;
            _errorMessage = null;
          });
        },
        activeColor: const Color(0xFF3EA75F),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(title),
        subtitle: Text(subtitle),
        dense: true,
        selected: isSelected,
      ),
    );
  }

  Future<void> _saveIp() async {
    if (_selectedMode == ApiConnectionMode.hosted) {
      await widget.apiIpService.saveConnectionMode(_selectedMode);
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    final ip = _controller.text.trim();

    if (!ApiIpService.isValidIp(ip)) {
      setState(() {
        _errorMessage = 'Digite um IP valido. Ex: 192.168.31.41';
      });
      return;
    }

    await widget.apiIpService.saveApiIpDigits(ip);
    await widget.apiIpService.saveConnectionMode(_selectedMode);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
