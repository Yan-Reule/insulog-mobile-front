import 'package:flutter/material.dart';
import 'package:insulog/states/report_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:insulog/widgets/main_body_widget.dart';
import 'package:insulog/widgets/report/export_report_body_widget.dart';
import 'package:insulog/widgets/report/export_report_header_widget.dart';

class ReportExportScreen extends StatefulWidget {
  const ReportExportScreen({super.key, required this.state});

  final ReportState state;

  @override
  State<ReportExportScreen> createState() => _ReportExportScreenState();
}

class _ReportExportScreenState extends State<ReportExportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.state.openExportReport();
    });
  }

  @override
  void dispose() {
    widget.state.closeExportReport();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: AnimatedBuilder(
        animation: widget.state,
        builder: (context, _) => Semantics(
          label: widget.state.isExporting
              ? 'Gerando relatório. Aguarde.'
              : 'Exportar relatório',
          liveRegion: true,
          child: SizedBox(
            width: size.width * 0.4,
            height: size.height * 0.08,
            child: CustomButtonWidget(
              onPressed: widget.state.isExportBusy
                  ? null
                  : () => widget.state.exportReport(context),
              isLoading: widget.state.isExporting,
              loadingColor: Colors.white,
              text: 'Exportar',
              isFontBold: true,
              icon: Icons.file_download_outlined,
              textColor: Colors.white,
              onpressTextColor: Colors.white,
              bgColor: const Color(0xFF3EA75F),
              onpressBgColor: const Color.fromARGB(255, 31, 88, 49),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: const BoxShadow(
                color: Color.fromARGB(80, 0, 0, 0),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: AnimatedBuilder(
        animation: widget.state,
        builder: (context, _) => MainBody(
          children: Column(
            children: [
              ExportReportHeaderWidget(size: size, state: widget.state),

              Expanded(
                child: AbsorbPointer(
                  absorbing: widget.state.isExportBusy,
                  child: ExportReportBodyWidget(
                    size: size,
                    state: widget.state,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
