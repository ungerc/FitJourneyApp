import SwiftUI

/// A celebratory view shown when all goals have been completed.
/// Displays a trophy icon and encourages users to set new goals.
struct CompletedGoalsView: View {
    @Environment(NavigationRouter.self) private var navigationRouter

    /// The number of goals that have been completed
    let completedCount: Int
    
    var body: some View {
        VStack(spacing: 20) {
            // Trophy icon with animation
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
            }
            
            VStack(spacing: 8) {
                Text("Congratulations!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("You've completed all \(completedCount) goals!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Call to action
            VStack(spacing: 12) {
                Text("Ready for new challenges?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    navigationRouter.navigate(to: .goals)
                }) {
                    Label("View Goals", systemImage: "target")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
}
