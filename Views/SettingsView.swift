import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.modelContext) private var modelContext
    @State private var showExportAlert = false
    @State private var exportMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Apariencia")) {
                    Toggle("Modo oscuro", isOn: $isDarkMode)
                }

                Section(header: Text("Datos")) {
                    Button("Exportar historial CSV") {
                        exportHistory()
                    }
                    Button("Eliminar todo el historial") {
                        deleteAllHistory()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Configuración")
            .alert("Exportación", isPresented: $showExportAlert) {
                Button("Aceptar", role: .cancel) {}
            } message: {
                Text(exportMessage)
            }
        }
    }

    private func exportHistory() {
        let query = Query<WorkSession> {
            true
        }
        guard let sessions = try? modelContext.fetch(query) else {
            exportMessage = "No se pudo leer el historial."
            showExportAlert = true
            return
        }

        do {
            let url = try CSVExportService.exportCSV(from: sessions)
            exportMessage = "CSV generado en: \(url.path)"
        } catch {
            exportMessage = error.localizedDescription
        }
        showExportAlert = true
    }

    private func deleteAllHistory() {
        let query = Query<WorkSession> {
            true
        }
        if let sessions = try? modelContext.fetch(query) {
            sessions.forEach(modelContext.delete)
            try? modelContext.save()
        }
    }
}
