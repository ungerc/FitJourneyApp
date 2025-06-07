import SwiftUI
import FitnessTracker

// Helper view to load a goal if not already in the view model
struct GoalDetailLoader: View {
    let goalId: String
    let goalService: GoalServiceProtocol
    let goalViewModel: FitnessTracker.GoalViewModel
    @State private var goal: FitnessTracker.Goal?
    @State private var isLoading = true
    @State private var error: Error?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading goal...")
            } else if let goal = goal {
                FitnessTracker.GoalDetailView(goal: goal)
                    .environment(goalViewModel)
            } else {
                ContentUnavailableView("Goal Not Found", 
                                     systemImage: "target",
                                     description: Text("The goal could not be found."))
            }
        }
        .task {
            await loadGoal()
        }
    }
    
    private func loadGoal() async {
        do {
            // First try to find in existing goals
            if let existingGoal = goalViewModel.goals.first(where: { $0.id == goalId }) {
                goal = existingGoal
            } else {
                // If not found, fetch all goals
                let goals = try await goalService.fetchGoals()
                goal = goals.first { $0.id == goalId }
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
