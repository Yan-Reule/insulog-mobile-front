import 'package:flutter/material.dart';
import 'package:insulog/states/report_state.dart';

class ExportReportSummaryWidget extends StatelessWidget {
  const ExportReportSummaryWidget({super.key, required this.state});

  final ReportState state;

  Future<void> _selectPeriod(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 10, 12, 31),
      initialDateRange: state.exportWeekRange,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Selecione o início e o fim da semana',
      // saveText: 'Confirmar',
      // cancelText: 'Cancelar',
      fieldStartLabelText: 'Data inicial',
      fieldEndLabelText: 'Data final',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3EA75F),
            primary: const Color(0xFF3EA75F),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: const Color(0xFF171717),
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            rangePickerBackgroundColor: Colors.white,
            rangePickerSurfaceTintColor: Colors.transparent,
            rangePickerShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFFCCCCCC)),
            ),
            rangePickerHeaderBackgroundColor: const Color(0xFF3EA75F),
            rangePickerHeaderForegroundColor: Colors.white,
            rangePickerHeaderHelpStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            rangePickerHeaderHeadlineStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            rangeSelectionBackgroundColor: const Color(0xFFE2F2E7),
            dividerColor: const Color(0xFFEEEEEE),
            todayBorder: const BorderSide(color: Color(0xFF3EA75F)),
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: child!,
              ),
            ),
          ),
        ),
      ),
    );
    if (range != null && context.mounted) state.selectExportWeekRange(range);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFCCCCCC)),
                ),
              ),
              child: const Text(
                'Exportação de Registros',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF171717),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
              child: Column(
                children: [
                  _row(
                    'Data',
                    state.exportDateLabel,
                    compactLabel: true,
                    action: state.exportPeriod == ReportExportPeriod.week
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Semana anterior',
                                    onPressed: state.canGoToPreviousExportWeek
                                        ? state.previousExportWeek
                                        : null,
                                    icon: const Icon(Icons.chevron_left),
                                    color: const Color(0xFF3EA75F),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _periodLine(
                                          'Semana ${state.exportWeekNumber}',
                                        ),
                                        const SizedBox(height: 4),
                                        _periodLine(
                                          '${state.selectedMonth} de ${state.selectedYear}',
                                        ),
                                        const SizedBox(height: 8),
                                        _periodLine(
                                          state.exportDateLabel,
                                          highlighted: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Próxima semana',
                                    onPressed: state.canGoToNextExportWeek
                                        ? state.nextExportWeek
                                        : null,
                                    icon: const Icon(Icons.chevron_right),
                                    color: const Color(0xFF3EA75F),
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () => _selectPeriod(context),
                                icon: const Icon(
                                  Icons.edit_calendar_outlined,
                                  size: 18,
                                ),
                                label: const Text('Editar período'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF3EA75F),
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                  if (state.exportPeriod == ReportExportPeriod.week)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(
                              0xFF3EA75F,
                            ).withValues(alpha: 0.6),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  _row('Formato', state.exportFormatLabel),
                  _row('Tipo de Dados', 'Glicose, insulina, período'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodLine(String text, {bool highlighted = false}) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: highlighted ? 20 : 16,
          fontWeight: highlighted ? FontWeight.w700 : FontWeight.w600,
          color: highlighted
              ? const Color(0xFF171717)
              : const Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    Widget? action,
    bool compactLabel = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (compactLabel)
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            )
          else
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            fit: compactLabel ? FlexFit.tight : FlexFit.loose,
            flex: 2,
            child:
                action ??
                Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF242424),
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
