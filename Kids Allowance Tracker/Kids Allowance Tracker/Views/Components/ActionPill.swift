import SwiftUI

struct ActionPill: View {
    let title: String
    let iconName: String
    let iconColor: Color
    let tint: Color
    let rotation: Double
    
    init(title: String, systemImage: String, tint: Color) {
        self.title = title
        self.iconName = systemImage
        self.iconColor = .white
        self.tint = tint
        self.rotation = 0
    }
    
    init(title: String, pawColor: Color, tint: Color, isUpward: Bool) {
        self.title = title
        self.iconName = "pawprint.fill"
        self.iconColor = pawColor
        self.tint = tint
        self.rotation = isUpward ? 0 : 180
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .font(.title2)
                .rotationEffect(.degrees(rotation))
                .padding(10)
                .background(tint)
                .clipShape(Circle())
            
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 90)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(tint.opacity(0.25))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.white.opacity(0.2))
        )
    }
}

#Preview("Paw Buttons") {
    HStack(spacing: 12) {
        ActionPill(title: "Add income", pawColor: .pink, tint: Color.pink.opacity(0.3), isUpward: true)
        ActionPill(title: "Add spending", pawColor: .black, tint: Color.black.opacity(0.3), isUpward: false)
    }
    .padding()
    .background(
        LinearGradient(
            colors: [Color.Sky, Color.OceanBlue],
            startPoint: .top,
            endPoint: .bottom
        )
    )
}
