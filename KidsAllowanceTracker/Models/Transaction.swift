import Foundation
import SwiftUI

enum TransactionType: String, CaseIterable, Identifiable {
    case income
    case expense

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .income:
            return "arrow.down.circle.fill"
        case .expense:
            return "arrow.up.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .income:
            return .green
        case .expense:
            return .red
        }
    }
}

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let date: Date
    let amount: Double
    let type: TransactionType
    let accent: Color

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        let sign = type == .expense ? "-" : "+"
        let base = formatter.string(from: NSNumber(value: abs(amount))) ?? "$0"
        return "\(sign)\(base)"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

extension Transaction {
    static let sample: [Transaction] = [
        Transaction(
            title: "Weekly Homework A",
            subtitle: "Reward saved",
            date: .now,
            amount: 5,
            type: .income,
            accent: .Mint
        ),
        Transaction(
            title: "Ride Bike to School",
            subtitle: "Daily streak",
            date: .now.addingTimeInterval(-86_400),
            amount: 5,
            type: .income,
            accent: .OceanBlue
        ),
        Transaction(
            title: "New Story Book",
            subtitle: "Reading is fun!",
            date: .now.addingTimeInterval(-2 * 86_400),
            amount: 12,
            type: .expense,
            accent: .Sunset
        ),
        Transaction(
            title: "Puzzle Toy",
            subtitle: "Weekend treat",
            date: .now.addingTimeInterval(-3 * 86_400),
            amount: 8,
            type: .expense,
            accent: .Rose
        )
    ]
}
