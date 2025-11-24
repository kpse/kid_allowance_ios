import SwiftUI

/// Quick icon generator for different sizes
/// Use this in a preview to see how your icon looks at various sizes
struct AppIconGenerator: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Jennifer's Money")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.OceanBlue)
                
                Text("App Icon Preview at Different Sizes")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                // Different sizes for testing
                VStack(spacing: 20) {
                    iconRow(size: 180, label: "iPhone (180×180)")
                    iconRow(size: 120, label: "iPhone (120×120)")
                    iconRow(size: 87, label: "Settings (87×87)")
                    iconRow(size: 60, label: "Spotlight (60×60)")
                    iconRow(size: 40, label: "Notification (40×40)")
                }
                .padding()
            }
            .padding(.vertical, 40)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func iconRow(size: CGFloat, label: String) -> some View {
        HStack(spacing: 20) {
            AppIconView()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: size * 0.225, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.headline)
                Text("\(Int(size))×\(Int(size)) pixels")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    AppIconGenerator()
}

#Preview("Export Size - 1024×1024") {
    AppIconView()
        .frame(width: 1024, height: 1024)
}

#Preview("iPhone Size - 180×180") {
    AppIconView()
        .frame(width: 180, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
}

#Preview("Settings Size - 87×87") {
    AppIconView()
        .frame(width: 87, height: 87)
        .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
}
