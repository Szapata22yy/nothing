import Foundation
import SwiftData

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var sessions: [WorkSession] = []
    @Published var selectedSession: WorkSession?
    @Published var isEditing = false
    @Published var errorMessage: String = ""
    @Published var showError = false

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        fetchSessions()
    }

    func fetchSessions() {
        let query = Query<WorkSession> {
            true
        }
        guard let results = try? context.fetch(query) else {
            sessions = []
            return
        }
        sessions = results.sorted(by: { $0.startDate > $1.startDate })
    }

    func deleteSession(_ session: WorkSession) {
        context.delete(session)
        saveContext()
    }

    func deleteAllSessions() {
        sessions.forEach(context.delete)
        saveContext()
    }

    func updateSession(_ session: WorkSession, startDate: Date, endDate: Date?) {
        session.startDate = startDate
        session.endDate = endDate
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
            fetchSessions()
        } catch {
            errorMessage = "No se pudo guardar el historial."
            showError = true
        }
    }
}
