import SwiftUI

/// Use this view to generate your app icon
/// 1. Run the app in preview or on a device
/// 2. Take a screenshot
/// 3. Use an app icon generator to create all sizes
/// Recommended: https://www.appicon.co or use Xcode's asset catalog
struct AppIconView: View {
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [.Sky, .OceanBlue, .Mint],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: -10) {
                // Cute kitten face
                ZStack {
                    // Head
                    Circle()
                        .fill(.white)
                        .frame(width: 160, height: 160)
                        .overlay(
                            Circle()
                                .stroke(Color.OceanBlue.opacity(0.3), lineWidth: 4)
                        )
                    
                    VStack(spacing: 8) {
                        // Ears
                        HStack(spacing: 80) {
                            // Left ear
                            Triangle()
                                .fill(.white)
                                .frame(width: 40, height: 50)
                                .overlay(
                                    Triangle()
                                        .fill(Color.pink.opacity(0.3))
                                        .scaleEffect(0.6)
                                )
                                .rotationEffect(.degrees(-15))
                                .offset(y: -20)
                            
                            // Right ear
                            Triangle()
                                .fill(.white)
                                .frame(width: 40, height: 50)
                                .overlay(
                                    Triangle()
                                        .fill(Color.pink.opacity(0.3))
                                        .scaleEffect(0.6)
                                )
                                .rotationEffect(.degrees(15))
                                .offset(y: -20)
                        }
                        .offset(y: 30)
                        
                        // Face features
                        VStack(spacing: 12) {
                            // Eyes with cute expression
                            HStack(spacing: 30) {
                                // Left eye
                                ZStack {
                                    Circle()
                                        .fill(Color.OceanBlue)
                                        .frame(width: 20, height: 20)
                                    Circle()
                                        .fill(.black)
                                        .frame(width: 13, height: 13)
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 6, height: 6)
                                        .offset(x: -3, y: -3)
                                }
                                
                                // Right eye
                                ZStack {
                                    Circle()
                                        .fill(Color.OceanBlue)
                                        .frame(width: 20, height: 20)
                                    Circle()
                                        .fill(.black)
                                        .frame(width: 13, height: 13)
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 6, height: 6)
                                        .offset(x: -3, y: -3)
                                }
                            }
                            
                            // Cute blush marks
                            HStack(spacing: 70) {
                                Circle()
                                    .fill(Color.pink.opacity(0.3))
                                    .frame(width: 18, height: 18)
                                
                                Circle()
                                    .fill(Color.pink.opacity(0.3))
                                    .frame(width: 18, height: 18)
                            }
                            .offset(y: -8)
                            
                            // Nose and mouth
                            VStack(spacing: 6) {
                                // Nose
                                Triangle()
                                    .fill(Color.pink)
                                    .frame(width: 12, height: 10)
                                    .rotationEffect(.degrees(180))
                                
                                // Mouth
                                HStack(spacing: 3) {
                                    // Left whisker curve
                                    Path { path in
                                        path.move(to: CGPoint(x: 0, y: 0))
                                        path.addQuadCurve(
                                            to: CGPoint(x: 15, y: 10),
                                            control: CGPoint(x: 5, y: 10)
                                        )
                                    }
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(width: 15, height: 10)
                                    
                                    // Right whisker curve
                                    Path { path in
                                        path.move(to: CGPoint(x: 15, y: 0))
                                        path.addQuadCurve(
                                            to: CGPoint(x: 0, y: 10),
                                            control: CGPoint(x: 10, y: 10)
                                        )
                                    }
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(width: 15, height: 10)
                                }
                            }
                        }
                        .offset(y: -5)
                    }
                }
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                
                // Dollar sign badge
                ZStack {
                    Circle()
                        .fill(Color.Mint)
                        .frame(width: 70, height: 70)
                        .shadow(color: Color.Mint.opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Text("$")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .offset(y: 40)
            }
        }
        .frame(width: 1024, height: 1024) // App Store size
    }
}

// Helper shape for triangle (ears and nose)
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    AppIconView()
}

#Preview("Icon Size") {
    AppIconView()
        .frame(width: 180, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
}
