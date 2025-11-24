import Foundation
import SwiftUI

enum TransactionType: String, CaseIterable, Identifiable, Codable {
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

struct Transaction: Identifiable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let date: Date
    let amount: Double
    let type: TransactionType
    // Color is not Codable by default, so we'll store a string representation or just use a default for now if needed,
    // but looking at the code, `accent` is used. We can make it computed or ignore it for persistence if we want,
    // OR better, we can make a Codable wrapper for Color or just store a hex string/enum.
    // For simplicity in this "kid friendly" app, let's store a custom enum or string for color, OR just not persist it and pick one based on type/random.
    // However, the existing code uses `accent: Color`.
    // Let's change `accent` to be a computed property based on a stored `accentName` string, or just make it simple.
    // Actually, looking at `Color+Theme.swift`, we have static colors. Let's add a `ThemeColor` enum that is Codable.
    
    // Wait, I can't easily change the whole app structure in one go without breaking things.
    // Let's see... `Transaction` has `let accent: Color`.
    // I will change `accent` to be non-persisted or handle it.
    // Actually, for a quick fix to make it Codable, I can exclude `accent` from CodingKeys and provide a default,
    // OR I can change `accent` to `accentColorName: String` and compute the color.
    // Let's go with `accentColorName` approach but I need to see if I can modify `Transaction` safely.
    // The `Transaction` struct is used in `DashboardViewModel` sample data.
    
    // Let's try to keep it simple. I'll add a `CodableColor` struct or similar? No that's too much boilerplate.
    // I will change `accent` to `tintName: String` and add a computed `accent: Color`.
    
    let tintName: String
    
    var accent: Color {
        switch tintName {
        case "OceanBlue": return .OceanBlue
        case "Mint": return .Mint
        case "Sunset": return .Sunset
        case "Lavender": return .Lavender
        case "Rose": return .Rose
        case "Sky": return .Sky
        case "Ink": return .Ink
        default: return .OceanBlue
        }
    }
    
    // We need to keep the init compatible if possible, or update call sites.
    // Updating call sites is better.
    
    init(id: UUID = UUID(), title: String, subtitle: String, date: Date, amount: Double, type: TransactionType, tintName: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.amount = amount
        self.type = type
        self.tintName = tintName
    }

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
            tintName: "Mint"
        ),
        Transaction(
            title: "Ride Bike to School",
            subtitle: "Daily streak",
            date: .now.addingTimeInterval(-86_400),
            amount: 5,
            type: .income,
            tintName: "OceanBlue"
        ),
        Transaction(
            title: "New Story Book",
            subtitle: "Reading is fun!",
            date: .now.addingTimeInterval(-2 * 86_400),
            amount: 12,
            type: .expense,
            tintName: "Sunset"
        ),
        Transaction(
            title: "Puzzle Toy",
            subtitle: "Weekend treat",
            date: .now.addingTimeInterval(-3 * 86_400),
            amount: 8,
            type: .expense,
            tintName: "Rose"
        )
    ]
}
