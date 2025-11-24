import SwiftUI

/// Cute cat decorations to use throughout the app
struct CatDecoration: View {
    enum Style {
        case paw
        case face
        case sleeping
        case playing
        case heart
    }
    
    let style: Style
    let size: CGFloat
    let color: Color
    
    init(style: Style = .paw, size: CGFloat = 24, color: Color = .OceanBlue) {
        self.style = style
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Group {
            switch style {
            case .paw:
                pawView
            case .face:
                faceView
            case .sleeping:
                sleepingView
            case .playing:
                playingView
            case .heart:
                heartView
            }
        }
        .frame(width: size, height: size)
    }
    
    private var pawView: some View {
        ZStack {
            // Main pad
            Circle()
                .fill(color)
                .frame(width: size * 0.5, height: size * 0.6)
                .offset(y: size * 0.1)
            
            // Toe beans
            HStack(spacing: size * 0.1) {
                Circle()
                    .fill(color)
                    .frame(width: size * 0.25, height: size * 0.3)
                Circle()
                    .fill(color)
                    .frame(width: size * 0.25, height: size * 0.3)
                Circle()
                    .fill(color)
                    .frame(width: size * 0.25, height: size * 0.3)
            }
            .offset(y: -size * 0.25)
        }
    }
    
    private var faceView: some View {
        ZStack {
            // Face circle
            Circle()
                .fill(color.opacity(0.2))
            
            VStack(spacing: size * 0.1) {
                // Eyes
                HStack(spacing: size * 0.3) {
                    Circle()
                        .fill(color)
                        .frame(width: size * 0.15, height: size * 0.15)
                    Circle()
                        .fill(color)
                        .frame(width: size * 0.15, height: size * 0.15)
                }
                
                // Nose
                Triangle()
                    .fill(color)
                    .frame(width: size * 0.12, height: size * 0.1)
                    .rotationEffect(.degrees(180))
                
                // Smile
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addQuadCurve(
                        to: CGPoint(x: size * 0.3, y: 0),
                        control: CGPoint(x: size * 0.15, y: size * 0.1)
                    )
                }
                .stroke(color, lineWidth: 1.5)
                .frame(width: size * 0.3, height: size * 0.1)
            }
            .offset(y: size * 0.05)
        }
    }
    
    private var sleepingView: some View {
        ZStack {
            // Body
            Capsule()
                .fill(color.opacity(0.3))
                .frame(width: size * 0.8, height: size * 0.5)
            
            // Head
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: size * 0.4, height: size * 0.4)
                .offset(x: -size * 0.2, y: -size * 0.1)
            
            // Zzz
            VStack(spacing: 2) {
                Text("z")
                    .font(.system(size: size * 0.2))
                    .foregroundStyle(color)
                Text("z")
                    .font(.system(size: size * 0.15))
                    .foregroundStyle(color.opacity(0.7))
            }
            .offset(x: size * 0.3, y: -size * 0.2)
        }
    }
    
    private var playingView: some View {
        ZStack {
            // Yarn ball
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Yarn lines
            ForEach(0..<3) { i in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addCurve(
                        to: CGPoint(x: size * 0.4, y: size * 0.1),
                        control1: CGPoint(x: size * 0.1, y: size * 0.2),
                        control2: CGPoint(x: size * 0.3, y: -size * 0.1)
                    )
                }
                .stroke(color, lineWidth: 1)
                .rotationEffect(.degrees(Double(i) * 60))
            }
            
            // Paw reaching for yarn
            Image(systemName: "pawprint.fill")
                .font(.system(size: size * 0.3))
                .foregroundStyle(color)
                .offset(x: size * 0.3, y: size * 0.3)
        }
    }
    
    private var heartView: some View {
        ZStack {
            // Heart shape
            Image(systemName: "heart.fill")
                .font(.system(size: size * 0.6))
                .foregroundStyle(color.opacity(0.3))
            
            // Small paw on heart
            Image(systemName: "pawprint.fill")
                .font(.system(size: size * 0.3))
                .foregroundStyle(color)
        }
    }
}

// Animated cat decoration that bounces
struct BouncingCat: View {
    @State private var isAnimating = false
    let style: CatDecoration.Style
    let size: CGFloat
    let color: Color
    
    var body: some View {
        CatDecoration(style: style, size: size, color: color)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// Floating cat decoration (for special moments)
struct FloatingCat: View {
    @State private var offset: CGFloat = 0
    let style: CatDecoration.Style
    let size: CGFloat
    let color: Color
    
    var body: some View {
        CatDecoration(style: style, size: size, color: color)
            .offset(y: offset)
            .animation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true),
                value: offset
            )
            .onAppear {
                offset = -10
            }
    }
}

#Preview("All Cat Styles") {
    VStack(spacing: 30) {
        Text("Cat Decorations 🐱")
            .font(.title.bold())
        
        HStack(spacing: 40) {
            VStack {
                CatDecoration(style: .paw, size: 60, color: .OceanBlue)
                Text("Paw")
                    .font(.caption)
            }
            
            VStack {
                CatDecoration(style: .face, size: 60, color: .Mint)
                Text("Face")
                    .font(.caption)
            }
            
            VStack {
                CatDecoration(style: .sleeping, size: 60, color: .Lavender)
                Text("Sleeping")
                    .font(.caption)
            }
        }
        
        HStack(spacing: 40) {
            VStack {
                CatDecoration(style: .playing, size: 60, color: .Sunset)
                Text("Playing")
                    .font(.caption)
            }
            
            VStack {
                CatDecoration(style: .heart, size: 60, color: .pink)
                Text("Heart")
                    .font(.caption)
            }
        }
        
        Divider()
            .padding()
        
        Text("Animated Versions")
            .font(.headline)
        
        HStack(spacing: 40) {
            VStack {
                BouncingCat(style: .paw, size: 50, color: .OceanBlue)
                Text("Bouncing")
                    .font(.caption)
            }
            
            VStack {
                FloatingCat(style: .face, size: 50, color: .Mint)
                Text("Floating")
                    .font(.caption)
            }
        }
    }
    .padding()
}
