import Foundation
import SwiftUI
import Combine

final class DashboardViewModel: ObservableObject {
    @Published var kidName: String = "Jennifer"
    @Published var balance: Double = 0
    @Published var streakDays: Int = 0
    @Published var todayCompleted: Int = 0
    @Published var todayTotal: Int = 2
    @Published var showConfetti: Bool = false

    @Published var transactions: [Transaction] = []

    private let defaults = UserDefaults.standard
    private let transactionsKey = "savedTransactions"
    private let balanceKey = "savedBalance"
    private let todayCompletedKey = "savedTodayCompleted"
    private let streakKey = "savedStreak"

    init() {
        loadData()
    }

    var incomeRules: [IncomeRule] {
        [
            IncomeRule(title: "Bike to school", reward: "$5/day", icon: "bicycle", tint: Color.OceanBlue, amount: 5, frequency: .daily),
            IncomeRule(title: "All-A homework", reward: "$5/week", icon: "checkmark.seal.fill", tint: Color.Mint, amount: 5, frequency: .weekly)
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

    func addTransaction(title: String, subtitle: String, amount: Double, type: TransactionType, tintName: String) {
        let transaction = Transaction(
            title: title,
            subtitle: subtitle,
            date: Date(),
            amount: amount,
            type: type,
            tintName: tintName
        )
        withAnimation {
            transactions.insert(transaction, at: 0)
            if type == .income {
                balance += amount
            } else {
                balance -= amount
            }
            saveData()
        }
    }

    func completeQuest(title: String, amount: Double, tintName: String) {
        // Prevent duplicate completion for "Bike to school" if we wanted to be strict, but for now just let them add it.
        // Actually, the UI shows a checkmark based on `todayCompleted`.
        // Let's increment `todayCompleted` and add the transaction.
        
        withAnimation {
            if todayCompleted < todayTotal {
                todayCompleted += 1
                
                // Add transaction
                addTransaction(
                    title: title,
                    subtitle: "Quest completed!",
                    amount: amount,
                    type: .income,
                    tintName: tintName
                )
                
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showConfetti = false
                }
                saveData()
            }
        }
    }

    func addSampleExpense() {
        // Kept for backward compatibility or testing, but updated to use new addTransaction
        addTransaction(
            title: "Comic Book",
            subtitle: "Friendly fun",
            amount: 9,
            type: .expense,
            tintName: "Lavender"
        )
    }

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            defaults.set(encoded, forKey: transactionsKey)
        }
        defaults.set(balance, forKey: balanceKey)
        defaults.set(todayCompleted, forKey: todayCompletedKey)
        defaults.set(streakDays, forKey: streakKey)
    }

    private func loadData() {
        if let data = defaults.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        } else {
            transactions = Transaction.sample
        }
        
        balance = defaults.double(forKey: balanceKey)
        if balance == 0 && transactions.isEmpty {
             // Initial state if needed, but let's stick to 0 or sample data logic
             // If we loaded sample transactions, we should probably calculate balance from them or just set a default.
             // For now, if no saved data, we use sample transactions. Let's calculate balance from sample.
             if transactions.count == Transaction.sample.count {
                 balance = 87 // Default from original code
             }
        }
        
        todayCompleted = defaults.integer(forKey: todayCompletedKey)
        streakDays = defaults.integer(forKey: streakKey)
        if streakDays == 0 { streakDays = 4 } // Default
    }
}

enum RuleFrequency: String, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
}

struct IncomeRule: Identifiable {
    let id = UUID()
    let title: String
    let reward: String
    let icon: String
    let tint: Color
    let amount: Double
    let frequency: RuleFrequency
}
