import SwiftUI

struct ActionPill: View {
    let title: String
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.white)
                .font(.title3)
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

#Preview {
    VStack {
        ActionPill(title: "Add income", systemImage: "arrow.down.circle.fill", tint: .Mint)
    }
    .padding()
    .background(Color.OceanBlue)
}
