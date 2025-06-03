import SwiftUI
import UIKit

struct ConfettiView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        EmitterView(isEmitting: isShowing)
            .allowsHitTesting(false)
            .ignoresSafeArea()
    }
}

struct EmitterView: UIViewRepresentable {
    var isEmitting: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Remove existing emitter layers when updating
        uiView.layer.sublayers?.removeAll(where: { $0 is CAEmitterLayer })
        
        if isEmitting {
            // Create and configure the emitter layer
            let emitter = createEmitterLayer()
            uiView.layer.addSublayer(emitter)
            
            // Position the emitter at the top of the screen
            emitter.emitterPosition = CGPoint(
                x: uiView.bounds.width / 2,
                y: -50
            )
            emitter.emitterSize = CGSize(width: uiView.bounds.width, height: 1)
            emitter.emitterShape = .line
            emitter.renderMode = .oldestLast
            
            // Start emitting
            emitter.beginTime = CACurrentMediaTime()
            
            // Stop after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                emitter.birthRate = 0
            }
        }
    }
    
    private func createEmitterLayer() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        
        // Configure the emitter
        emitter.emitterCells = createEmitterCells()
        emitter.birthRate = 10
        
        return emitter
    }
    
    private func createEmitterCells() -> [CAEmitterCell] {
        // Define colors for confetti
        let colors: [UIColor] = [
            .systemRed, .systemBlue, .systemGreen, .systemYellow,
            .systemOrange, .systemPurple, .systemPink, .systemTeal
        ]
        
        // Create different shapes of confetti
        var cells: [CAEmitterCell] = []
        
        // Add rectangular confetti
        for color in colors {
            cells.append(createConfettiCell(color: color, type: .rectangle))
        }
        
        // Add circular confetti
        for color in colors {
            cells.append(createConfettiCell(color: color, type: .circle))
        }
        
        return cells
    }
    
    private enum ConfettiType {
        case rectangle
        case circle
    }
    
    private func createConfettiCell(color: UIColor, type: ConfettiType) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        // Create the confetti content
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        
        switch type {
        case .rectangle:
            context.fill(CGRect(origin: .zero, size: size))
        case .circle:
            context.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        cell.contents = image?.cgImage
        
        // Configure emission properties
        cell.birthRate = 5
        cell.lifetime = 10.0
        cell.lifetimeRange = 2.0
        cell.velocity = 200
        cell.velocityRange = 100
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spin = CGFloat.pi
        cell.spinRange = CGFloat.pi * 2
        
        // Configure appearance
        cell.scale = 0.5
        cell.scaleRange = 0.3
        cell.scaleSpeed = -0.1
        
        // Add some physics
        cell.yAcceleration = 70
        
        // Add some randomness to the movement
        cell.xAcceleration = CGFloat.random(in: -20...20)
        
        return cell
    }
}

#Preview {
    ConfettiView(isShowing: .constant(true))
}
