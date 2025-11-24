//
//  ContentView.swift
//  Kids Allowance Tracker
//
//  Main dashboard view
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    
    private var balance: Double {
        transactions.reduce(0) { total, transaction in
            switch transaction.type {
            case .income:
                return total + transaction.amount
            case .expense:
                return total - transaction.amount
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Balance Card
                    BalanceCard(balance: balance)
                    
                    // Income Rules Card
                    IncomeRulesCard()
                    
                    // Recent Transactions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Transactions")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        if transactions.isEmpty {
                            EmptyStateView()
                        } else {
                            ForEach(transactions.prefix(10)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("My Money 💰")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            addSampleIncome()
                        } label: {
                            Label("Add Income", systemImage: "plus.circle.fill")
                        }
                        
                        Button {
                            addSampleExpense()
                        } label: {
                            Label("Add Expense", systemImage: "minus.circle.fill")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func addSampleIncome() {
        let income = Transaction(
            amount: 5.0,
            type: .income,
            category: "Bike to School",
            note: "Rode bike today!"
        )
        modelContext.insert(income)
    }
    
    private func addSampleExpense() {
        let expense = Transaction(
            amount: 3.0,
            type: .expense,
            category: "Snacks",
            note: "Ice cream"
        )
        modelContext.insert(expense)
    }
}

// MARK: - Balance Card

struct BalanceCard: View {
    let balance: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Total Balance")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("$\(balance, specifier: "%.2f")")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.tint.opacity(0.15))
        }
        .padding(.horizontal)
    }
}

// MARK: - Income Rules Card

struct IncomeRulesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to Earn Money")
                .font(.headline)
            
            HStack(spacing: 12) {
                Image(systemName: "bicycle")
                    .font(.title2)
                    .foregroundStyle(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bike to School")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("+$5 per day")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundStyle(.yellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("All-A Homework")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("+$5 per week (every Saturday)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.green.opacity(0.1))
        }
        .padding(.horizontal)
    }
}

// MARK: - Transaction Row

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                .font(.title2)
                .foregroundStyle(transaction.type == .income ? .green : .red)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.category)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(transaction.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            Text("\(transaction.type == .income ? "+" : "-")$\(transaction.amount, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(transaction.type == .income ? .green : .red)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No transactions yet")
                .font(.headline)
            
            Text("Tap + to add your first income or expense!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
