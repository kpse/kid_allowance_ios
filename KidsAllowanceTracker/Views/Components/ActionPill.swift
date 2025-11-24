import SwiftUI

struct ActionPill: View {
    let title: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.white)
                .font(.subheadline)
                .padding(8)
                .background(tint)
                .clipShape(Circle())
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
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
