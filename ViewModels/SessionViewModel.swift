import Foundation
import SwiftUI
import SwiftData

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var activeStartDate: Date?
    @Published var elapsedTime: TimeInterval = 0
    @Published var isWorking = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    private var timer: Timer?
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        restoreActiveSession()
        startTimerIfNeeded()
    }

    func toggleWorkState() {
        if isWorking {
            finishWork()
        } else {
            startWork()
        }
    }

    private func startWork() {
        let now = Date()
        let newSession = WorkSession(startDate: now)
        context.insert(newSession)
        do {
            try context.save()
            activeStartDate = now
            isWorking = true
            elapsedTime = 0
            startTimerIfNeeded()
        } catch {
            showError(with: "No se pudo iniciar el registro de trabajo.")
        }
    }

    private func finishWork() {
        guard let activeStartDate else { return }
        let activeSessions = fetchActiveSessions()
        guard let currentSession = activeSessions.first(where: { $0.startDate == activeStartDate && $0.endDate == nil }) else {
            showError(with: "No se encontró la sesión activa.")
            return
        }

        currentSession.endDate = Date()
        do {
            try context.save()
            resetActiveState()
        } catch {
            showError(with: "No se pudo finalizar el registro de trabajo.")
        }
    }

    private func restoreActiveSession() {
        let activeSessions = fetchActiveSessions()
        if let activeSession = activeSessions.sorted(by: { $0.startDate > $1.startDate }).first {
            activeStartDate = activeSession.startDate
            isWorking = true
            elapsedTime = Date().timeIntervalSince(activeSession.startDate)
        }
    }

    private func fetchActiveSessions() -> [WorkSession] {
        let query = Query<WorkSession> {
            $0.endDate == nil
        }
        return (try? context.fetch(query)) ?? []
    }

    private func resetActiveState() {
        activeStartDate = nil
        isWorking = false
        elapsedTime = 0
        stopTimer()
    }

    private func startTimerIfNeeded() {
        stopTimer()
        guard isWorking else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let startDate = self.activeStartDate else { return }
            self.elapsedTime = Date().timeIntervalSince(startDate)
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func formattedElapsedTime() -> String {
        DateService.formattedDuration(elapsedTime)
    }

    private func showError(with message: String) {
        errorMessage = message
        showError = true
    }
}
