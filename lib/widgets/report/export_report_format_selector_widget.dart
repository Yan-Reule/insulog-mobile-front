import 'package:flutter/material.dart';
import 'package:insulog/services/api/report_export_service.dart';
import 'package:insulog/states/report_state.dart';

class ExportReportFormatSelectorWidget extends StatelessWidget {
  const ExportReportFormatSelectorWidget({super.key, required this.state});

  final ReportState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _option(
              format: ReportFormat.pdf,
              title: 'PDF',
              subtitle: 'Formato para médicos e clínicas',
              icon: Icons.picture_as_pdf_outlined,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFCCCCCC)),
            _option(
              format: ReportFormat.xlsx,
              title: 'Planilha',
              subtitle: 'Compatível com Excel e Sheets Google',
              icon: Icons.description,
            ),
          ],
        ),
      ),
    );
  }

  Widget _option({
    required ReportFormat format,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = state.exportFormat == format;
    return Semantics(
      label: '$title. $subtitle',
      checked: selected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        onTap: () => state.selectExportFormat(format),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F5F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF50CC55), size: 26),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF171717),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected
                      ? const Color(0xFF3EA75F)
                      : const Color(0xFF909090),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
