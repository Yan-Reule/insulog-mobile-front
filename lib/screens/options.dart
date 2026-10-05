import 'package:flutter/material.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/services/api/auth_service.dart';
import 'package:insulog/services/local/saved_login_service.dart';
import 'package:insulog/widgets/main_body_widget.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  Future<Map<String, dynamic>>? _doctorLinkFuture;
  bool _isLinking = false;

  @override
  void initState() {
    super.initState();
    _doctorLinkFuture = AuthService().getDoctorLink();
  }

  void _refreshDoctorLink() {
    setState(() => _doctorLinkFuture = AuthService().getDoctorLink());
  }

  Future<void> _showLinkDialog() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Vincular médico'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Código de vínculo',
            hintText: 'INSU-XXXXXXXX',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Vincular'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (code == null || code.trim().isEmpty || !mounted) return;

    setState(() => _isLinking = true);
    try {
      await AuthService().redeemDoctorLink(code);
      if (!mounted) return;
      _refreshDoctorLink();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Médico vinculado com sucesso.')),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) setState(() => _isLinking = false);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await SavedLoginService().clearCredentials();
    Globals().clearUsername();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: MainBody(
        children: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.07),
              const Text(
                'Opções',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: size.height * 0.025),
              Card(
                elevation: 0,
                color: const Color(0xFFF5F8F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2EAE3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _doctorLinkFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vínculo com médico', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(snapshot.error.toString()),
                            TextButton.icon(
                              onPressed: _refreshDoctorLink,
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
                            const Text('Médico vinculado', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 12),
                            Text(doctor['nome']?.toString() ?? 'Médico', style: const TextStyle(fontSize: 16)),
                            if (doctor['email'] != null) Text(doctor['email'].toString()),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vincular médico', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          const Text('Você pode usar o Insulog sem vínculo. Se recebeu um código do médico, informe-o aqui.'),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: _isLinking ? null : _showLinkDialog,
                              icon: _isLinking ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.link),
                              label: Text(_isLinking ? 'Vinculando...' : 'Inserir código'),
                              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3EA75F)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                ),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
