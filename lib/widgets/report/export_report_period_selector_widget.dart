import 'package:flutter/material.dart';
import 'package:insulog/states/report_state.dart';

class ExportReportPeriodSelectorWidget extends StatelessWidget {
  const ExportReportPeriodSelectorWidget({
    super.key,
    required this.state,
    required this.size,
  });

  final Size size;
  final ReportState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color:  const Color(0xFFCCCCCC) ,
        ),
      ),
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              _option(ReportExportPeriod.week, 'Semana'),
              const SizedBox(
                height: 26,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              _option(ReportExportPeriod.month, 'Mês'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(ReportExportPeriod period, String label) {
    final selected = state.exportPeriod == period;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          onTap: () => state.selectExportPeriod(period),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut, 
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF3EA75F)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: size.height * 0.025,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.white : const Color(0xFF4D4D4D),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
