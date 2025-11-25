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
    @Published var completedQuests: Set<String> = []
    @Published var questCompletionDates: [String: Date] = [:]

    private let defaults = UserDefaults.standard
    private let transactionsKey = "savedTransactions"
    private let balanceKey = "savedBalance"
    private let todayCompletedKey = "savedTodayCompleted"
    private let streakKey = "savedStreak"
    private let completedQuestsKey = "savedCompletedQuests"
    private let questCompletionDatesKey = "savedQuestCompletionDates"
    private let lastResetCheckKey = "lastResetCheck"

    init() {
        loadData()
        checkAndResetQuests()
    }

    var incomeRules: [IncomeRule] {
        [
            IncomeRule(title: "Bike to school", reward: "$5/day", icon: "bicycle", tint: Color.OceanBlue, amount: 5, frequency: .daily),
            IncomeRule(title: "All-A homework", reward: "$5/week", icon: "checkmark.seal.fill", tint: Color.Mint, amount: 5, frequency: .weekly),
            IncomeRule(title: "Room tidy bonus", reward: "$2/day", icon: "sparkles", tint: Color.Lavender, amount: 2, frequency: .daily)
        ]
    }
    
    // Map quest titles to their frequency
    private var questFrequencies: [String: RuleFrequency] {
        [
            "Bike to school": .daily,
            "All homework A": .weekly,
            "Room tidy bonus": .daily
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
        withAnimation {
            // Check if the quest is already completed
            if completedQuests.contains(title) {
                // Uncomplete: Remove from completed set
                completedQuests.remove(title)
                questCompletionDates.removeValue(forKey: title)
                todayCompleted = max(0, todayCompleted - 1)
                
                // Find and remove the most recent transaction for this quest
                if let index = transactions.firstIndex(where: { $0.title == title }) {
                    let transaction = transactions[index]
                    transactions.remove(at: index)
                    
                    // Adjust balance
                    if transaction.type == .income {
                        balance -= transaction.amount
                    } else {
                        balance += transaction.amount
                    }
                }
            } else {
                // Complete: Add to completed set
                completedQuests.insert(title)
                questCompletionDates[title] = Date()
                todayCompleted += 1
                
                // Add transaction with cat-themed subtitle
                addTransaction(
                    title: title,
                    subtitle: "Purr-fect! Quest completed! 🐾",
                    amount: amount,
                    type: .income,
                    tintName: tintName
                )
                
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showConfetti = false
                }
            }
            saveData()
        }
    }
    
    /// Check if quests need to be reset based on their frequency
    func checkForQuestResets() {
        checkAndResetQuests()
    }
    
    private func checkAndResetQuests() {
        let now = Date()
        let calendar = Calendar.current
        var needsReset = false
        
        // Check each completed quest
        for questTitle in completedQuests {
            guard let frequency = questFrequencies[questTitle],
                  let completionDate = questCompletionDates[questTitle] else {
                continue
            }
            
            var shouldReset = false
            
            switch frequency {
            case .daily:
                // Reset if it's a different day
                shouldReset = !calendar.isDate(completionDate, inSameDayAs: now)
                
            case .weekly:
                // Reset if it's a new week (after Sunday midnight)
                if let lastSunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: completionDate)),
                   let thisSunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) {
                    shouldReset = lastSunday < thisSunday
                }
            }
            
            if shouldReset {
                completedQuests.remove(questTitle)
                questCompletionDates.removeValue(forKey: questTitle)
                todayCompleted = max(0, todayCompleted - 1)
                needsReset = true
            }
        }
        
        if needsReset {
            saveData()
        }
        
        // Save the last reset check time
        defaults.set(now, forKey: lastResetCheckKey)
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
        defaults.set(Array(completedQuests), forKey: completedQuestsKey)
        
        // Save quest completion dates
        if let encoded = try? JSONEncoder().encode(questCompletionDates) {
            defaults.set(encoded, forKey: questCompletionDatesKey)
        }
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
        
        if let savedQuests = defaults.array(forKey: completedQuestsKey) as? [String] {
            completedQuests = Set(savedQuests)
        }
        
        // Load quest completion dates
        if let data = defaults.data(forKey: questCompletionDatesKey),
           let decoded = try? JSONDecoder().decode([String: Date].self, from: data) {
            questCompletionDates = decoded
        }
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
