import Foundation
import SwiftData

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var totalHoursToday = "00:00"
    @Published var totalHoursWeek = "00:00"
    @Published var totalHoursMonth = "00:00"
    @Published var averageDay = "00:00"
    @Published var averageWeek = "00:00"
    @Published var averageMonth = "00:00"
    @Published var totalHistorical = "00:00"
    @Published var totalSessions = 0

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        calculateStatistics()
    }

    func calculateStatistics() {
        let sessions = fetchCompletedSessions()
        totalSessions = sessions.count
        totalHistorical = DateService.formattedDuration(sessions.reduce(0) { $0 + $1.duration })
        totalHoursToday = DateService.formattedDuration(totalDuration(for: sessions, period: .today))
        totalHoursWeek = DateService.formattedDuration(totalDuration(for: sessions, period: .week))
        totalHoursMonth = DateService.formattedDuration(totalDuration(for: sessions, period: .month))
        averageDay = averageDuration(for: sessions, period: .today)
        averageWeek = averageDuration(for: sessions, period: .week)
        averageMonth = averageDuration(for: sessions, period: .month)
    }

    private func fetchCompletedSessions() -> [WorkSession] {
        let query = Query<WorkSession> {
            $0.endDate != nil
        }
        return (try? context.fetch(query)) ?? []
    }

    private func totalDuration(for sessions: [WorkSession], period: Period) -> TimeInterval {
        let range = period.dateRange
        return sessions
            .filter { session in
                guard let end = session.endDate else { return false }
                return range.contains(session.startDate) || range.contains(end)
            }
            .reduce(0) { $0 + $1.duration }
    }

    private func averageDuration(for sessions: [WorkSession], period: Period) -> String {
        let range = period.dateRange
        let periodSessions = sessions.filter { session in
            guard let end = session.endDate else { return false }
            return range.contains(session.startDate) || range.contains(end)
        }
        guard !periodSessions.isEmpty else {
            return "00:00"
        }
        let total = periodSessions.reduce(0) { $0 + $1.duration }
        let days = period.daysCount
        return DateService.formattedDuration(total / TimeInterval(days))
    }
}

private enum Period {
    case today
    case week
    case month

    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        switch self {
        case .today:
            let start = calendar.startOfDay(for: now)
            let end = calendar.date(byAdding: .day, value: 1, to: start)!.addingTimeInterval(-1)
            return start ... end
        case .week:
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let end = calendar.date(byAdding: .day, value: 7, to: start)!.addingTimeInterval(-1)
            return start ... end
        case .month:
            let start = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let end = calendar.date(byAdding: .month, value: 1, to: start)!.addingTimeInterval(-1)
            return start ... end
        }
    }

    var daysCount: Int {
        switch self {
        case .today: return 1
        case .week: return 7
        case .month: return Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 30
        }
    }
}
