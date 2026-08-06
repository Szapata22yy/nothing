import SwiftUI
import SwiftData

@main
struct HorasSamuelApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    private let modelContainer = try! ModelContainer(for: [WorkSession.self])

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(modelContainer)
    }
}
