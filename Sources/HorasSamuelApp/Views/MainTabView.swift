import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            HomeView(viewModel: SessionViewModel(context: modelContext))
                .tabItem {
                    Label("Inicio", systemImage: "play.circle.fill")
                }

            HistoryView(viewModel: HistoryViewModel(context: modelContext))
                .tabItem {
                    Label("Historial", systemImage: "list.bullet.rectangle")
                }

            StatisticsView(viewModel: StatisticsViewModel(context: modelContext))
                .tabItem {
                    Label("Estadísticas", systemImage: "chart.bar.xaxis")
                }

            SettingsView()
                .tabItem {
                    Label("Configuración", systemImage: "gearshape")
                }
        }
    }
}
