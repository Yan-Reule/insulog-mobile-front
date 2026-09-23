import 'package:flutter/material.dart';
import 'package:insulog/states/report_state.dart';
import 'package:insulog/widgets/report/stats_report_widget.dart';

class ExportReportStatsWidget extends StatelessWidget {
  const ExportReportStatsWidget({
    super.key,
    required this.state,
    required this.size,
  });

  final ReportState state;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final summary = state.isLoadingExportSummary
            ? null
            : state.exportSummary;

        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: size.width * 0.03,
                children: [
                  StatsReportWidget(
                    size: size,
                    tipe: 3,
                    title: 'Média',
                    value: summary?.media,
                  ),
                  StatsReportWidget(
                    size: size,
                    tipe: 5,
                    title: 'Normais',
                    value: summary?.totalNormais,
                  ),
                  StatsReportWidget(
                    size: size,
                    tipe: 2,
                    title: 'Altos',
                    value: summary?.totalAlertas,
                  ),
                  StatsReportWidget(
                    size: size,
                    tipe: 4,
                    title: 'Baixos',
                    value: summary?.totalBaixos,
                  ),
                  StatsReportWidget(
                    size: size,
                    tipe: 1,
                    title: 'Registros',
                    value: summary?.registros.length,
                  ),
                ],
              ),
            ),
            if (state.exportSummaryError != null) ...[
              const SizedBox(height: 8),
              Text(
                state.exportSummaryError!,
                style: const TextStyle(color: Color(0xFF333333)),
              ),
              TextButton(
                onPressed: state.refreshExportSummary,
                child: const Text('Tentar novamente'),
              ),
            ],
          ],
        );
      },
    );
  }
}
