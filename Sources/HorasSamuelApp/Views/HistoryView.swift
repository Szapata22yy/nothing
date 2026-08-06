import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel
    @State private var showDeleteConfirmation = false
    @State private var showExportMessage = false
    @State private var exportURL: URL?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sessions) { session in
                    NavigationLink(destination: SessionDetailView(session: session, viewModel: viewModel)) {
                        HistoryRow(session: session)
                    }
                }
                .onDelete(perform: deleteSession)
            }
            .navigationTitle("Historial")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Eliminar todo") {
                        showDeleteConfirmation = true
                    }
                    .foregroundStyle(.red)
                }
            }
            .confirmationDialog("Eliminar todo el historial?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("Eliminar todo", role: .destructive) {
                    viewModel.deleteAllSessions()
                }
                Button("Cancelar", role: .cancel) {}
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("Aceptar", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        offsets.map { viewModel.sessions[$0] }.forEach(viewModel.deleteSession)
    }
}
