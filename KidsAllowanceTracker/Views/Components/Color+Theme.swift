import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }

    static let Ink = Color(hex: 0x1C2A3A)
    static let Sky = Color(hex: 0xE8F4FF)
    static let OceanBlue = Color(hex: 0x4A90E2)
    static let Mint = Color(hex: 0x5CD6C4)
    static let Sunset = Color(hex: 0xFF8A5C)
    static let Lavender = Color(hex: 0xB6A1FF)
    static let Rose = Color(hex: 0xFF6B93)
    static let PillGrey = Color(hex: 0xD8E0E6)
}
