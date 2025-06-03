import SwiftUI

struct ConfettiView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            if isShowing {
                ForEach(0..<100) { _ in
                    ConfettiPiece()
                }
            }
        }
    }
}

struct ConfettiPiece: View {
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var rotation = Double.random(in: 0...360)
    @State private var scale = Double.random(in: 0.5...1.5)
    @State private var opacity = 1.0
    
    private let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    private let shapes = ["circle.fill", "square.fill", "triangle.fill", "heart.fill", "star.fill"]
    
    private var randomColor: Color {
        colors.randomElement() ?? .blue
    }
    
    private var randomShape: String {
        shapes.randomElement() ?? "circle.fill"
    }
    
    var body: some View {
        Image(systemName: randomShape)
            .foregroundColor(randomColor)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .position(
                x: position.x,
                y: position.y
            )
            .onAppear {
                // Random starting position at the top of the screen
                let screenWidth = UIScreen.main.bounds.width
                position = CGPoint(
                    x: Double.random(in: 0...screenWidth),
                    y: -50
                )
                
                // Animate the confetti falling
                withAnimation(.easeOut(duration: Double.random(in: 1...3))) {
                    position = CGPoint(
                        x: Double.random(in: 0...screenWidth),
                        y: UIScreen.main.bounds.height + 50
                    )
                    rotation += Double.random(in: 180...360)
                    opacity = 0
                }
            }
    }
}

#Preview {
    ConfettiView(isShowing: .constant(true))
}
import SwiftUI

struct ConfettiView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            if isShowing {
                ForEach(0..<100) { _ in
                    ConfettiPiece()
                }
            }
        }
    }
}

struct ConfettiPiece: View {
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var rotation = Double.random(in: 0...360)
    @State private var scale = Double.random(in: 0.5...1.5)
    @State private var opacity = 1.0
    
    private let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    private let shapes = ["circle.fill", "square.fill", "triangle.fill", "heart.fill", "star.fill"]
    
    private var randomColor: Color {
        colors.randomElement() ?? .blue
    }
    
    private var randomShape: String {
        shapes.randomElement() ?? "circle.fill"
    }
    
    var body: some View {
        Image(systemName: randomShape)
            .foregroundColor(randomColor)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .position(
                x: position.x,
                y: position.y
            )
            .onAppear {
                // Random starting position at the top of the screen
                let screenWidth = UIScreen.main.bounds.width
                position = CGPoint(
                    x: Double.random(in: 0...screenWidth),
                    y: -50
                )
                
                // Animate the confetti falling
                withAnimation(.easeOut(duration: Double.random(in: 1...3))) {
                    position = CGPoint(
                        x: Double.random(in: 0...screenWidth),
                        y: UIScreen.main.bounds.height + 50
                    )
                    rotation += Double.random(in: 180...360)
                    opacity = 0
                }
            }
    }
}

#Preview {
    ConfettiView(isShowing: .constant(true))
}
