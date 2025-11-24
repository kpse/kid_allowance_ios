import Foundation
import SwiftUI

final class DashboardViewModel: ObservableObject {
    @Published var kidName: String = "Mia"
    @Published var balance: Double = 87
    @Published var streakDays: Int = 4
    @Published var todayCompleted: Int = 1
    @Published var todayTotal: Int = 2
    @Published var showConfetti: Bool = false

    @Published var transactions: [Transaction] = Transaction.sample

    var incomeRules: [IncomeRule] {
        [
            IncomeRule(title: "Bike to school", reward: "+$5/day", icon: "bicycle", tint: .OceanBlue),
            IncomeRule(title: "All-A homework", reward: "+$5/week", icon: "checkmark.seal.fill", tint: .Mint)
        ]
    }

    var streakText: String {
        "\(streakDays)-day streak"
    }

    var balanceText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: balance)) ?? "$0"
    }

    func addSampleExpense() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.2)) {
            let expense = Transaction(
                title: "Comic Book",
                subtitle: "Friendly fun",
                date: .now,
                amount: 9,
                type: .expense,
                accent: .Lavender
            )
            transactions.insert(expense, at: 0)
            balance -= expense.amount
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showConfetti = false
            }
        }
    }
}

struct IncomeRule: Identifiable {
    let id = UUID()
    let title: String
    let reward: String
    let icon: String
    let tint: Color
}
