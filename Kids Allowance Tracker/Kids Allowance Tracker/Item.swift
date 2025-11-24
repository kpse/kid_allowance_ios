//
//  Item.swift
//  Kids Allowance Tracker
//
//  Created by Louis Suo on 11/24/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
