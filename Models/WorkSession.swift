import Foundation
import SwiftData

@Model
final class WorkSession: Identifiable {
    @Attribute(.unique) var id: UUID = .init()
    var startDate: Date
    var endDate: Date?

    init(startDate: Date, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }

    var duration: TimeInterval {
        (endDate ?? Date()).timeIntervalSince(startDate)
    }

    var completed: Bool {
        endDate != nil
    }

    var dateText: String {
        DateService.formattedDate(startDate)
    }

    var startText: String {
        DateService.formattedTime(startDate)
    }

    var endText: String {
        DateService.formattedTime(endDate ?? Date())
    }

    var durationText: String {
        DateService.formattedDuration(duration)
    }
}
