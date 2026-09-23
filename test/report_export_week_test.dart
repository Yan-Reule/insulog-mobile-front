import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/states/report_state.dart';

void main() {
  test('semanas cobrem o mês sem lacunas e navegação respeita limites', () {
    final state = ReportState();
    final weeks = state.selectedMonthWeeks;
    expect(weeks.first.start.day, 1);
    expect(weeks.last.end.add(const Duration(days: 1)).day, 1);
    for (var i = 0; i < weeks.length; i++) {
      expect(weeks[i].duration.inDays, lessThanOrEqualTo(6));
      if (i > 0) {
        expect(weeks[i].start.weekday, DateTime.monday);
        expect(weeks[i - 1].end.add(const Duration(days: 1)), weeks[i].start);
      }
      if (i < weeks.length - 1) {
        expect(weeks[i].end.weekday, DateTime.sunday);
      }
    }
    expect(state.exportWeekRange, weeks.first);
    state.previousExportWeek();
    expect(state.exportWeekNumber, 1);
    for (var i = 1; i < weeks.length; i++) {
      state.nextExportWeek();
      expect(state.exportWeekRange, weeks[i]);
    }
    expect(state.canGoToNextExportWeek, isFalse);
    state.nextExportWeek();
    expect(state.exportWeekNumber, weeks.length);
    state.previousExportWeek();
    expect(state.exportWeekRange, weeks[weeks.length - 2]);
  });
}
