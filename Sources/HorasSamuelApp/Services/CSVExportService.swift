import Foundation

final class CSVExportService {
    enum ExportError: LocalizedError {
        case emptyData
        case saveFailed

        var errorDescription: String? {
            switch self {
            case .emptyData:
                return "No hay registros para exportar."
            case .saveFailed:
                return "No se pudo generar el archivo CSV."
            }
        }
    }

    static func exportCSV(from sessions: [WorkSession]) throws -> URL {
        guard !sessions.isEmpty else {
            throw ExportError.emptyData
        }

        let header = "Fecha,Hora de inicio,Hora de finalización,Duración"
        let lines = sessions
            .sorted { $0.startDate > $1.startDate }
            .map { session -> String in
                let date = DateService.csvDate(session.startDate)
                let startTime = DateService.csvTime(session.startDate)
                let endTime = DateService.csvTime(session.endDate ?? session.startDate)
                let duration = DateService.formattedDuration(session.duration)
                return "\(date),\(startTime),\(endTime),\(duration)"
            }

        let content = ([header] + lines).joined(separator: "\n")
        let fileName = "registro_de_horas_\(Int(Date().timeIntervalSince1970)).csv"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            throw ExportError.saveFailed
        }
    }
}
