import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insulog/services/api/api_service.dart';
import 'package:insulog/services/api/report_export_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:insulog/DTO/ENUMs/enum_registroGlicose.dart';
import 'package:insulog/DTO/ENUMs/enum_historico_registro_glicose.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/services/api/data_service.dart';
import 'package:insulog/services/local/saved_login_service.dart';

class ReportDay {
  const ReportDay({
    required this.date,
    required this.day,
    required this.weekday,
    required this.shortWeekday,
    required this.totalDays,
  });

  final DateTime date;
  final int day;
  final String weekday;
  final String shortWeekday;
  final int totalDays;
}

class ReportRecordWeek {
  const ReportRecordWeek({
    required this.number,
    required this.startDay,
    required this.endDay,
    required this.days,
  });

  final int number;
  final int startDay;
  final int endDay;
  final List<ReportRecordDay> days;
}

class ReportRecordDay {
  const ReportRecordDay({required this.day, required this.records});

  final int day;
  final List<RegistroGlicose> records;
}

enum ReportExportPeriod { week, month }

class ReportState extends ChangeNotifier {
  ReportFormat _exportFormat = ReportFormat.pdf;

  ReportFormat get exportFormat => _exportFormat;
  String get exportFormatLabel =>
      _exportFormat == ReportFormat.pdf ? 'PDF' : 'Planilha';

  void selectExportFormat(ReportFormat format) {
    if (_exportFormat == format) return;
    _exportFormat = format;
    notifyListeners();
  }

  ReportExportPeriod _exportPeriod = ReportExportPeriod.week;

  ReportExportPeriod get exportPeriod => _exportPeriod;

  DateTimeRange? _exportWeekRange;
  int _exportWeekIndex = 0;
  int get exportWeekNumber => _exportWeekIndex + 1;
  bool get canGoToPreviousExportWeek => _exportWeekIndex > 0;
  bool get canGoToNextExportWeek =>
      _exportWeekIndex < selectedMonthWeeks.length - 1;

  DateTimeRange get exportWeekRange =>
      _exportWeekRange ?? selectedMonthWeeks[_exportWeekIndex];

  int _weekNumberForDay(int day) {
    final first = DateTime(_selectedDate.year, _selectedDate.month);
    return ((day + first.weekday - 2) ~/ 7) + 1;
  }

  List<DateTimeRange> get selectedMonthWeeks {
    final first = DateTime(_selectedDate.year, _selectedDate.month);
    final last = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    return List.generate(_weekNumberForDay(last.day), (index) {
      final startDay = (1 + index * 7 - (first.weekday - 1)).clamp(1, last.day);
      final start = DateTime(first.year, first.month, startDay);
      final endDay = (startDay + DateTime.sunday - start.weekday).clamp(
        1,
        last.day,
      );
      return DateTimeRange(
        start: start,
        end: DateTime(first.year, first.month, endDay),
      );
    });
  }

  void previousExportWeek() {
    if (!canGoToPreviousExportWeek) return;
    _exportWeekIndex--;
    _exportWeekRange = null;
    _exportSelectionChanged();
  }

  void nextExportWeek() {
    if (!canGoToNextExportWeek) return;
    _exportWeekIndex++;
    _exportWeekRange = null;
    _exportSelectionChanged();
  }

  String get exportDateLabel {
    if (_exportPeriod == ReportExportPeriod.month) return selectedMonth;
    final range = exportWeekRange;
    String format(DateTime date) =>
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}';
    return '${format(range.start)} a ${format(range.end)}';
  }

  void selectExportWeekRange(DateTimeRange range) {
    if (_exportWeekRange == range) return;
    _exportWeekRange = range;
    _exportSelectionChanged();
  }

  void selectExportPeriod(ReportExportPeriod period) {
    if (_exportPeriod == period) return;
    _exportPeriod = period;
    _exportSelectionChanged();
  }

  HistoricoRegistroGlicoseResponse? _exportSummary;
  HistoricoRegistroGlicoseResponse? get exportSummary => _exportSummary;
  bool _isLoadingExportSummary = false;
  bool get isLoadingExportSummary => _isLoadingExportSummary;
  String? _exportSummaryError;
  String? get exportSummaryError => _exportSummaryError;
  bool _isExportScreenOpen = false;
  int _exportSummaryRequestId = 0;

  void openExportReport() {
    _isExportScreenOpen = true;
    unawaited(refreshExportSummary());
  }

  void closeExportReport() {
    _isExportScreenOpen = false;
    _exportSummaryRequestId++;
    _isLoadingExportSummary = false;
    _exportSummary = null;
    _exportSummaryError = null;
  }

  void _exportSelectionChanged() {
    _exportSummaryRequestId++;
    _exportSummary = null;
    _exportSummaryError = null;
    if (_isExportScreenOpen) {
      unawaited(refreshExportSummary());
    } else {
      notifyListeners();
    }
  }

  Future<void> refreshExportSummary() async {
    final requestId = ++_exportSummaryRequestId;
    final start = exportStart;
    final lastDay = exportEnd;
    final end = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
    _exportSummary = null;
    _exportSummaryError = null;
    _isLoadingExportSummary = true;
    notifyListeners();
    try {
      var userId = Globals().userId;
      if (userId <= 0) {
        userId = (await _savedLoginService.getCredentials())?.userId ?? 0;
      }
      if (userId <= 0) {
        throw DataException('Entre novamente para carregar o resumo.');
      }
      final response = await DataService().fetchHistoricoGlicose(
        userId,
        dataInicio: start,
        dataFim: end,
      );
      if (requestId != _exportSummaryRequestId) return;
      _exportSummary = response;
    } on DataException catch (error) {
      if (requestId != _exportSummaryRequestId) return;
      _exportSummaryError = error.message;
    } catch (_) {
      if (requestId != _exportSummaryRequestId) return;
      _exportSummaryError =
          'Não foi possível carregar o resumo. Tente novamente.';
    } finally {
      if (requestId == _exportSummaryRequestId) {
        _isLoadingExportSummary = false;
        notifyListeners();
      }
    }
  }

  bool _isExporting = false;
  bool _isSharingExport = false;

  bool get isExporting => _isExporting;
  bool get isExportBusy => _isExporting || _isSharingExport;

  Future<ReportFile> _fetchReport(ReportFormat format) async {
    final start = exportStart;
    final end = exportEnd;
    var userId = Globals().userId;
    if (userId <= 0) {
      userId = (await _savedLoginService.getCredentials())?.userId ?? 0;
    }
    if (userId <= 0) {
      throw ApiException(
        message: 'Entre novamente para exportar o relatório.',
        statusCode: 401,
      );
    }
    return ReportExportService().fetchReport(
      userId: userId,
      start: start,
      end: end,
      format: format,
    );
  }

  Future<void> exportReport(BuildContext context) async {
    if (isExportBusy) return;
    final format = _exportFormat;
    _isExporting = true;
    notifyListeners();
    try {
      final file = await _fetchReport(format);
      if (!context.mounted) return;
      _isExporting = false;
      _isSharingExport = true;
      notifyListeners();
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          title: 'Relatório Insulog',
          files: [XFile.fromData(file.bytes, mimeType: file.mimeType)],
          fileNameOverrides: [file.filename],
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível compartilhar o relatório. Tente novamente.',
            ),
          ),
        );
      }
    } finally {
      _isSharingExport = false;
      _isExporting = false;
      notifyListeners();
    }
  }

  ReportState._() {
    _selectedMonthDays = _createSelectedMonthDays();
  }

  static final ReportState instance = ReportState._();

  factory ReportState() => instance;

  static const int visibleReportRecordsLimit = 4;

  final SavedLoginService _savedLoginService = SavedLoginService();
  List<RegistroGlicose> _reportRecords = [];
  bool _isReportListOpen = false;
  int _media = 0;
  int _totalBaixos = 0;
  int _totalNormais = 0;
  int _totalAlertas = 0;
  int _requestId = 0;

  List<RegistroGlicose> get visibleRecords => _isReportListOpen
      ? List.unmodifiable(_reportRecords)
      : _reportRecords.take(visibleReportRecordsLimit).toList();
  int get totalRecords => _reportRecords.length;
  int get totalBaixos => _totalBaixos;
  int get totalNormais => _totalNormais;
  int get totalAlertas => _totalAlertas;
  int get media => _media;
  bool get hasHiddenRecords =>
      _reportRecords.length > visibleReportRecordsLimit;
  bool get canShowMoreRecords => !_isReportListOpen && hasHiddenRecords;
  bool get canShowLessRecords => _isReportListOpen && hasHiddenRecords;

  final List<String> listaMeses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  static const List<String> _weekdays = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  static const List<String> _shortWeekdays = [
    'SEG',
    'TER',
    'QUA',
    'QUI',
    'SEX',
    'SAB',
    'DOM',
  ];

  int get selectedDay => _selectedDay;
  int _selectedDay = 0;

  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month);
  late List<ReportDay> _selectedMonthDays;
  Timer? _monthHoldTimer;
  bool _monthHoldChangedValue = false;

  String get selectedMonth => listaMeses[_selectedDate.month - 1];

  int get selectedYear => _selectedDate.year;

  List<ReportDay> get selectedMonthDays => _selectedMonthDays;

  bool get canGoToNextMonth {
    final nextMonth = DateTime(_selectedDate.year, _selectedDate.month + 1);
    return nextMonth.year <= DateTime.now().year;
  }

  void setDay(int day) {
    if (day < 1 || day > _selectedMonthDays.length) {
      throw ArgumentError('Invalid day: $day');
    }

    if (_selectedDay == day) {
      _selectedDay = 0;
    } else {
      _selectedDay = day;
    }
    notifyListeners();
    unawaited(refreshReportRecords());
  }

  void nextMonth() {
    if (_monthHoldChangedValue) {
      _monthHoldChangedValue = false;
      return;
    }

    _changeMonth(1);
  }

  void previousMonth() {
    if (_monthHoldChangedValue) {
      _monthHoldChangedValue = false;
      return;
    }

    _changeMonth(-1);
  }

  void startNextMonthHold() {
    _startMonthHold(1);
  }

  void startPreviousMonthHold() {
    _startMonthHold(-1);
  }

  void stopMonthHold() {
    _monthHoldTimer?.cancel();
    _monthHoldTimer = null;
  }

  void _startMonthHold(int offset) {
    stopMonthHold();
    _monthHoldChangedValue = false;

    _monthHoldTimer = Timer.periodic(const Duration(milliseconds: 180), (_) {
      _monthHoldChangedValue = true;
      _changeMonth(offset);
    });
  }

  void _changeMonth(int offset) {
    final newDate = DateTime(_selectedDate.year, _selectedDate.month + offset);

    if (newDate.year > DateTime.now().year) {
      return;
    }

    _selectedDate = newDate;
    _exportWeekIndex = 0;
    _exportWeekRange = null;
    _selectedDay = 0;
    _isReportListOpen = false;
    _selectedMonthDays = _createSelectedMonthDays();
    _exportSelectionChanged();
    unawaited(refreshReportRecords());
  }

  List<ReportDay> _createSelectedMonthDays() {
    final lastDay = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
    ).day;

    return List<ReportDay>.unmodifiable(
      List<ReportDay>.generate(lastDay, (index) {
        final date = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          index + 1,
        );

        return ReportDay(
          date: date,
          day: date.day,
          weekday: _weekdays[date.weekday - 1],
          shortWeekday: _shortWeekdays[date.weekday - 1],
          totalDays: lastDay,
        );
      }),
    );
  }

  List<ReportRecordWeek> groupRecordsByWeek(List<RegistroGlicose> records) {
    final recordsByWeekAndDay = <int, Map<int, List<RegistroGlicose>>>{};
    final weeks = selectedMonthWeeks;

    for (final record in records) {
      final recordDate = record.horaDoRegistro;
      if (recordDate.year != _selectedDate.year ||
          recordDate.month != _selectedDate.month) {
        continue;
      }

      final weekNumber = _weekNumberForDay(recordDate.day);
      final recordsByDay = recordsByWeekAndDay.putIfAbsent(
        weekNumber,
        () => {},
      );
      recordsByDay.putIfAbsent(recordDate.day, () => []).add(record);
    }

    return recordsByWeekAndDay.entries
        .map((entry) {
          final range = weeks[entry.key - 1];

          return ReportRecordWeek(
            number: entry.key,
            startDay: range.start.day,
            endDay: range.end.day,
            days: entry.value.entries
                .map(
                  (dayEntry) => ReportRecordDay(
                    day: dayEntry.key,
                    records: List.unmodifiable(dayEntry.value),
                  ),
                )
                .toList(growable: false),
          );
        })
        .toList(growable: false);
  }

  DateTime get exportStart => _exportPeriod == ReportExportPeriod.week
      ? exportWeekRange.start
      : DateTime(_selectedDate.year, _selectedDate.month);

  DateTime get exportEnd => _exportPeriod == ReportExportPeriod.week
      ? exportWeekRange.end
      : DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

  Future<void> refreshReportRecords() async {
    final currentRequestId = ++_requestId;
    var userId = Globals().userId;
    if (userId <= 0) {
      final credentials = await _savedLoginService.getCredentials();
      userId = credentials?.userId ?? 0;
    }
    if (userId <= 0) return;

    final selectedDay = _selectedDay;
    final start = selectedDay == 0
        ? DateTime(_selectedDate.year, _selectedDate.month)
        : DateTime(_selectedDate.year, _selectedDate.month, selectedDay);
    final end = selectedDay == 0
        ? DateTime(_selectedDate.year, _selectedDate.month + 1, 0, 23, 59, 59)
        : DateTime(
            _selectedDate.year,
            _selectedDate.month,
            selectedDay,
            23,
            59,
            59,
          );
    try {
      final response = await DataService().fetchHistoricoGlicose(
        userId,
        dataInicio: start,
        dataFim: end,
      );
      if (currentRequestId != _requestId) return;

      _reportRecords = response.registros;
      _media = response.media;
      _totalBaixos = response.totalBaixos;
      _totalNormais = response.totalNormais;
      _totalAlertas = response.totalAlertas;
      _isReportListOpen = false;
      notifyListeners();
    } on DataException catch (error) {
      debugPrint(error.toString());
    }
  }

  void showMoreRecords() {
    if (!canShowMoreRecords) return;
    _isReportListOpen = true;
    notifyListeners();
  }

  void showLessRecords() {
    if (!canShowLessRecords) return;
    _isReportListOpen = false;
    notifyListeners();
  }

  void openReport() {
    _selectedDay = 0;
    _isReportListOpen = false;
    _reportRecords = [];
    _media = 0;
    _totalBaixos = 0;
    _totalNormais = 0;
    _totalAlertas = 0;
    notifyListeners();
    unawaited(refreshReportRecords());
  }

  void leaveReport() {
    stopMonthHold();
    _selectedDay = 0;
    _isReportListOpen = false;
    _requestId++;
  }

  @override
  void dispose() {
    stopMonthHold();
    super.dispose();
  }

  String returnCurrentDateLabel(ReportRecordWeek week) {
    return 'SEMANA ${week.number}: DIA ${week.startDay} ATÉ DIA ${week.endDay}';
  }

  String returnDayLabel(ReportRecordDay day) {
    return 'DIA ${day.day}';
  }
}
