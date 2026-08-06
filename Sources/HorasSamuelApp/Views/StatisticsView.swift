import SwiftUI

struct StatisticsView: View {
    @StateObject var viewModel: StatisticsViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    statisticsRow(title: "Hoy", value: viewModel.totalHoursToday, subtitle: "Horas trabajadas")
                    statisticsRow(title: "Esta semana", value: viewModel.totalHoursWeek, subtitle: "Horas trabajadas")
                    statisticsRow(title: "Este mes", value: viewModel.totalHoursMonth, subtitle: "Horas trabajadas")
                    statisticsRow(title: "Promedio diario", value: viewModel.averageDay, subtitle: "Horas")
                    statisticsRow(title: "Promedio semanal", value: viewModel.averageWeek, subtitle: "Horas")
                    statisticsRow(title: "Promedio mensual", value: viewModel.averageMonth, subtitle: "Horas")
                    statisticsRow(title: "Total histórico", value: viewModel.totalHistorical, subtitle: "Horas")
                    statisticsRow(title: "Jornadas", value: "\(viewModel.totalSessions)", subtitle: "Registros")
                }
                .padding()
            }
            .navigationTitle("Estadísticas")
        }
    }

    private func statisticsRow(title: String, value: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title)
                .bold()
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
