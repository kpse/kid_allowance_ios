import SwiftUI

@main
struct JennifersMoneyApp: App {
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
