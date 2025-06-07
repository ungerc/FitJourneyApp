import SwiftUI

/// Quick stats view showing summary of workouts and goals
struct QuickStatsView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    @State private var workoutCount = 0
    @State private var activeGoalsCount = 0
    @State private var completedGoalsCount = 0
    @State private var isLoading = true
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                StatItem(
                    title: "Total Workouts",
                    value: "\(workoutCount)",
                    icon: "figure.run",
                    color: .blue
                )
                
                Spacer()
                
                StatItem(
                    title: "Active Goals",
                    value: "\(activeGoalsCount)",
                    icon: "target",
                    color: .orange
                )
                
                Spacer()
                
                StatItem(
                    title: "Completed",
                    value: "\(completedGoalsCount)",
                    icon: "checkmark.circle",
                    color: .green
                )
            }
        }
        .padding(.vertical, 8)
        .task {
            await loadStats()
        }
        .overlay {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }
    
    @MainActor
    private func loadStats() async {
        isLoading = true
        
        // Fetch workouts
        if let workouts = try? await workoutAdapter.fetchWorkouts() {
            workoutCount = workouts.count
        }
        
        // Fetch goals
        if let goals = try? await goalAdapter.fetchGoals() {
            activeGoalsCount = goals.filter { $0.progress < 1.0 }.count
            completedGoalsCount = goals.filter { $0.progress >= 1.0 }.count
        }
        
        isLoading = false
    }
}
