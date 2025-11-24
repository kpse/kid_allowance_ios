import SwiftUI

/// Cat-themed celebration overlay for special achievements
struct CatCelebration: View {
    let message: String
    @State private var isAnimating = false
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Animated cat face
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.Mint, Color.OceanBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.Mint.opacity(0.5), radius: 20, x: 0, y: 10)
                    
                    VStack(spacing: 8) {
                        // Happy eyes
                        HStack(spacing: 20) {
                            Text("^")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                            Text("^")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        // Big smile
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addQuadCurve(
                                to: CGPoint(x: 40, y: 0),
                                control: CGPoint(x: 20, y: 15)
                            )
                        }
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 40, height: 15)
                    }
                }
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                
                // Success message
                VStack(spacing: 8) {
                    Text(message)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "pawprint.fill")
                            .foregroundStyle(Color.Mint)
                        Image(systemName: "pawprint.fill")
                            .foregroundStyle(Color.OceanBlue)
                        Image(systemName: "pawprint.fill")
                            .foregroundStyle(Color.Mint)
                    }
                    .font(.title3)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
            }
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                opacity = 1
            }
            
            withAnimation(
                .easeInOut(duration: 0.5)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

/// Small cat badge for milestones
struct CatBadge: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                VStack(spacing: 2) {
                    Image(systemName: "pawprint.fill")
                        .font(.title3)
                        .foregroundStyle(color)
                    Text("\(count)")
                        .font(.caption.bold())
                        .foregroundStyle(color)
                }
            }
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

/// Cute cat quote generator for motivation
struct CatQuote: View {
    let quotes = [
        "You're paws-itively amazing! 🐾",
        "Meow-velous work! 😻",
        "You're the cat's meow! 🐱",
        "Purr-fect progress! 💚",
        "Fur-tastic job! 🎉",
        "You're paw-some! ⭐",
        "Claw-ver moves! 🌟",
        "Whisker-licking good! 💪"
    ]
    
    var randomQuote: String {
        quotes.randomElement() ?? quotes[0]
    }
    
    var body: some View {
        HStack(spacing: 12) {
            CatDecoration(style: .face, size: 30, color: .OceanBlue)
            
            Text(randomQuote)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.OceanBlue.opacity(0.3), Color.Mint.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
    }
}

/// Paw prints trail decoration
struct PawPrintsTrail: View {
    let count: Int
    let color: Color
    let spacing: CGFloat
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<count, id: \.self) { index in
                Image(systemName: "pawprint.fill")
                    .font(.caption)
                    .foregroundStyle(color.opacity(Double(index + 1) / Double(count)))
                    .rotationEffect(.degrees(index % 2 == 0 ? -15 : 15))
            }
        }
    }
}

#Preview("Cat Celebration") {
    ZStack {
        Color.OceanBlue.ignoresSafeArea()
        CatCelebration(message: "Quest Complete!\nYou earned $5! 🎉")
    }
}

#Preview("Cat Badges") {
    HStack(spacing: 20) {
        CatBadge(count: 5, label: "Quests", color: Color.Mint)
        CatBadge(count: 12, label: "Days", color: Color.OceanBlue)
        CatBadge(count: 87, label: "Dollars", color: Color.Sunset)
    }
    .padding()
}

#Preview("Cat Quote") {
    VStack(spacing: 20) {
        CatQuote()
        CatQuote()
        CatQuote()
    }
    .padding()
    .background(Color.Sky)
}

#Preview("Paw Prints Trail") {
    VStack(spacing: 30) {
        PawPrintsTrail(count: 5, color: Color.OceanBlue, spacing: 12)
        PawPrintsTrail(count: 7, color: Color.Mint, spacing: 10)
        PawPrintsTrail(count: 4, color: Color.Sunset, spacing: 15)
    }
    .padding()
}
