//
//  Transaction.swift
//  Kids Allowance Tracker
//
//  Data model for income and expense transactions
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var date: Date
    var amount: Double
    var type: TransactionType
    var category: String
    var note: String
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        amount: Double,
        type: TransactionType,
        category: String,
        note: String = ""
    ) {
        self.id = id
        self.date = date
        self.amount = amount
        self.type = type
        self.category = category
        self.note = note
    }
    
    enum TransactionType: String, Codable {
        case income
        case expense
    }
}
