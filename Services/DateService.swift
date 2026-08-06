import Foundation

struct DateService {
    private static let spanishLocale = Locale(identifier: "es_ES")

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = spanishLocale
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = spanishLocale
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    private static let csvDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = spanishLocale
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let csvTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = spanishLocale
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    static func formattedDate(_ date: Date = .now) -> String {
        fullDateFormatter.string(from: date)
    }

    static func formattedTime(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }

    static func formattedDuration(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    static func csvDate(_ date: Date) -> String {
        csvDateFormatter.string(from: date)
    }

    static func csvTime(_ date: Date) -> String {
        csvTimeFormatter.string(from: date)
    }
}
