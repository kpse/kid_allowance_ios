import SwiftUI

@main
struct KidsAllowanceTrackerApp: App {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .environmentObject(viewModel)
            }
        }
    }
}
