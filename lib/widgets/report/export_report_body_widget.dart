import 'package:flutter/material.dart';
import 'package:insulog/states/report_state.dart';
import 'package:insulog/widgets/custom_container_widget.dart';
import 'package:insulog/widgets/report/export_report_period_selector_widget.dart';
import 'package:insulog/widgets/report/export_report_summary_widget.dart';
import 'package:insulog/widgets/report/export_report_stats_widget.dart';
import 'package:insulog/widgets/report/export_report_format_selector_widget.dart';

class ExportReportBodyWidget extends StatelessWidget {
  const ExportReportBodyWidget({
    super.key,
    required this.size,
    required this.state,
  });

  final Size size;
  final ReportState state;

  @override
  Widget build(BuildContext context) {
    return CustomContainerWidget(
      width: size.width,
      innerShadow: const InnerShadow(
        color: Color.fromARGB(80, 0, 0, 0),
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.width * 0.1),
          topRight: Radius.circular(size.width * 0.1),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.04,
          16,
          size.width * 0.04,
          size.height * 0.08 + 32,
        ),
        child: Column(
          children: [
            ExportReportPeriodSelectorWidget(state: state, size: size),
            const SizedBox(height: 16),
            ExportReportSummaryWidget(state: state),
            const SizedBox(height: 16),
            ExportReportStatsWidget(state: state, size: size),
            const SizedBox(height: 16),
            ExportReportFormatSelectorWidget(state: state),
          ],
        ),
      ),
    );
  }
}
