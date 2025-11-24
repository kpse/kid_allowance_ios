import SwiftUI

/// Custom paw print arrow shapes for transactions
struct PawArrow: View {
    enum Direction {
        case up      // Income (pink paw pointing up)
        case down    // Expense (black paw pointing down)
    }
    
    let direction: Direction
    let size: CGFloat
    
    init(direction: Direction, size: CGFloat = 40) {
        self.direction = direction
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Main paw print
            pawPrint
                .foregroundStyle(direction == .up ? Color.pink : Color.black)
                .rotationEffect(.degrees(direction == .up ? 0 : 180))
            
            // Arrow indicator
            arrowIndicator
                .foregroundStyle(direction == .up ? Color.pink.opacity(0.8) : Color.black.opacity(0.8))
        }
        .frame(width: size, height: size)
    }
    
    private var pawPrint: some View {
        ZStack {
            // Main pad (bottom/center)
            Ellipse()
                .frame(width: size * 0.5, height: size * 0.6)
                .offset(y: size * 0.15)
            
            // Toe beans (top three circles)
            HStack(spacing: size * 0.08) {
                // Left toe
                Circle()
                    .frame(width: size * 0.22, height: size * 0.28)
                    .offset(y: -size * 0.05)
                
                // Middle toe
                Circle()
                    .frame(width: size * 0.22, height: size * 0.28)
                    .offset(y: -size * 0.15)
                
                // Right toe
                Circle()
                    .frame(width: size * 0.22, height: size * 0.28)
                    .offset(y: -size * 0.05)
            }
            .offset(y: -size * 0.18)
        }
    }
    
    private var arrowIndicator: some View {
        VStack(spacing: 2) {
            if direction == .up {
                // Upward arrow chevron
                Image(systemName: "chevron.up")
                    .font(.system(size: size * 0.25, weight: .bold))
                    .offset(y: -size * 0.35)
            } else {
                // Downward arrow chevron (appears above the upside-down paw)
                Image(systemName: "chevron.down")
                    .font(.system(size: size * 0.25, weight: .bold))
                    .offset(y: size * 0.35)
            }
        }
    }
}

/// Animated paw arrow for emphasis
struct AnimatedPawArrow: View {
    let direction: PawArrow.Direction
    let size: CGFloat
    @State private var isAnimating = false
    
    var body: some View {
        PawArrow(direction: direction, size: size)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

/// Paw arrow badge with background
struct PawArrowBadge: View {
    let direction: PawArrow.Direction
    let size: CGFloat
    
    var backgroundColor: Color {
        direction == .up ? Color.pink.opacity(0.15) : Color.black.opacity(0.1)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size * 1.3, height: size * 1.3)
            
            PawArrow(direction: direction, size: size)
        }
    }
}

#Preview("Paw Arrows") {
    VStack(spacing: 40) {
        Text("Paw Print Arrows 🐾")
            .font(.title.bold())
        
        HStack(spacing: 60) {
            VStack(spacing: 12) {
                PawArrow(direction: .up, size: 60)
                Text("Income")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Pink Up")
                    .font(.caption2)
                    .foregroundStyle(.pink)
            }
            
            VStack(spacing: 12) {
                PawArrow(direction: .down, size: 60)
                Text("Expense")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Black Down")
                    .font(.caption2)
                    .foregroundStyle(.black)
            }
        }
        
        Divider()
            .padding()
        
        Text("Animated Versions")
            .font(.headline)
        
        HStack(spacing: 60) {
            VStack(spacing: 12) {
                AnimatedPawArrow(direction: .up, size: 50)
                Text("Bouncing")
                    .font(.caption)
            }
            
            VStack(spacing: 12) {
                AnimatedPawArrow(direction: .down, size: 50)
                Text("Bouncing")
                    .font(.caption)
            }
        }
        
        Divider()
            .padding()
        
        Text("With Badges")
            .font(.headline)
        
        HStack(spacing: 60) {
            VStack(spacing: 12) {
                PawArrowBadge(direction: .up, size: 40)
                Text("Income Badge")
                    .font(.caption)
            }
            
            VStack(spacing: 12) {
                PawArrowBadge(direction: .down, size: 40)
                Text("Expense Badge")
                    .font(.caption)
            }
        }
        
        Divider()
            .padding()
        
        Text("Different Sizes")
            .font(.headline)
        
        HStack(spacing: 30) {
            PawArrow(direction: .up, size: 30)
            PawArrow(direction: .up, size: 40)
            PawArrow(direction: .up, size: 50)
            PawArrow(direction: .up, size: 60)
        }
    }
    .padding()
}

#Preview("In Use - Transaction Icons") {
    VStack(spacing: 20) {
        // Mock transaction rows
        HStack(spacing: 16) {
            PawArrowBadge(direction: .up, size: 35)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Bike to school")
                    .font(.subheadline.weight(.semibold))
                Text("Quest completed!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("+$5")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.pink)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
        
        HStack(spacing: 16) {
            PawArrowBadge(direction: .down, size: 35)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Comic Book")
                    .font(.subheadline.weight(.semibold))
                Text("Fun purchase")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("-$9")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.black)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
