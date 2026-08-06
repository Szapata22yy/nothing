import SwiftUI

struct SessionDetailView: View {
    @ObservedObject var session: WorkSession
    @ObservedObject var viewModel: HistoryViewModel
    @State private var editedStartDate: Date
    @State private var editedEndDate: Date
    @State private var isEditingSession = false

    init(session: WorkSession, viewModel: HistoryViewModel) {
        self.session = session
        self.viewModel = viewModel
        _editedStartDate = State(initialValue: session.startDate)
        _editedEndDate = State(initialValue: session.endDate ?? session.startDate)
    }

    var body: some View {
        Form {
            Section(header: Text("Detalles")) {
                HStack {
                    Text("Fecha")
                    Spacer()
                    Text(session.dateText)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Inicio")
                    Spacer()
                    Text(session.startText)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Final")
                    Spacer()
                    Text(session.endDate != nil ? session.endText : "En curso")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Duración")
                    Spacer()
                    Text(session.durationText)
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Editar jornada")) {
                DatePicker("Inicio", selection: $editedStartDate, displayedComponents: [.date, .hourAndMinute])
                DatePicker("Final", selection: $editedEndDate, displayedComponents: [.date, .hourAndMinute])
            }

            Section {
                Button("Guardar cambios") {
                    viewModel.updateSession(session, startDate: editedStartDate, endDate: editedEndDate)
                }
            }
        }
        .navigationTitle("Registro")
        .navigationBarTitleDisplayMode(.inline)
    }
}
