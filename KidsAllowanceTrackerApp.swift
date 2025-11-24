//
//  KidsAllowanceTrackerApp.swift
//  Kids Allowance Tracker
//
//  Main app entry point
//

import SwiftUI
import SwiftData

@main
struct KidsAllowanceTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Transaction.self])
    }
}
