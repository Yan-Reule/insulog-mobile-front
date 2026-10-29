import 'package:flutter/material.dart';
import 'package:insulog/states/report_state.dart';

class ExportReportSummaryWidget extends StatelessWidget {
  const ExportReportSummaryWidget({super.key, required this.state});

  final ReportState state;

  static const Color green = Color(0xFF3EA75F);
  static const Color textColor = Color(0xFF171717);
  static const Color borderColor = Color(0xFFCCCCCC);

  Future<void> _selectPeriod(BuildContext context) async {
    final now = DateTime.now();

    final range = await showDateRangePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 10, 12, 31),
      initialDateRange: state.exportWeekRange,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Selecione o início e o fim do período',
      fieldStartLabelText: 'Data inicial',
      fieldEndLabelText: 'Data final',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: green,
            primary: green,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: textColor,
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            rangePickerBackgroundColor: Colors.white,
            rangePickerSurfaceTintColor: Colors.transparent,
            rangePickerShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: borderColor),
            ),
            rangePickerHeaderBackgroundColor: green,
            rangePickerHeaderForegroundColor: Colors.white,
            rangePickerHeaderHelpStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            rangePickerHeaderHeadlineStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            rangeSelectionBackgroundColor: Color(0xFFE2F2E7),
            dividerColor: Color(0xFFEEEEEE),
            todayBorder: BorderSide(color: green),
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: child!,
              ),
            ),
          ),
        ),
      ),
    );

    if (range != null && context.mounted) {
      state.selectExportWeekRange(range);
    }
  }

 
String _formatPeriod() {
  final start = state.exportWeekRange.start;
  final end = state.exportWeekRange.end;

  final startDay = start.day.toString().padLeft(2, '0');
  final endDay = end.day.toString().padLeft(2, '0');

  if (start.month == end.month && start.year == end.year) {
    return '$startDay a $endDay';
  }

  final startMonth = start.month.toString().padLeft(2, '0');
  final endMonth = end.month.toString().padLeft(2, '0');

  return '$startDay/$startMonth a $endDay/$endMonth';
}


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final isWeek = state.exportPeriod == ReportExportPeriod.week;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 22,
                        color: green,
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        'Período em Dias',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 42),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: isWeek
                    ? _buildWeekSelector(context)
                    : _buildMonthSelector(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekSelector(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navigationButton(
              icon: Icons.chevron_left,
              label: 'Semana anterior',
              onPressed: state.canGoToPreviousExportWeek
                  ? state.previousExportWeek
                  : null,
            ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPeriod(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${state.selectedMonth} de ${state.selectedYear}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),

            _navigationButton(
              icon: Icons.chevron_right,
              label: 'Próxima semana',
              onPressed: state.canGoToNextExportWeek
                  ? state.nextExportWeek
                  : null,
            ),
          ],
        ),

        const SizedBox(height: 12),

        TextButton.icon(
          onPressed: () => _selectPeriod(context),
          icon: const Icon(Icons.edit_calendar_outlined, size: 18),
          label: const Text('Editar período'),
          style: TextButton.styleFrom(
            foregroundColor: green,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '${state.selectedMonth} de ${state.selectedYear}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _navigationButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    final enabled = onPressed != null;

    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon, size: 26),
      color: enabled ? green : const Color(0xFFAAAAAA),
      disabledColor: const Color(0xFFAAAAAA),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: enabled ? green : borderColor),
        shape: const CircleBorder(),
        minimumSize: const Size(42, 42),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
