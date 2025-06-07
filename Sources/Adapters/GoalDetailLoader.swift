import SwiftUI
import Benefit

/// Helper view that loads a goal detail when it's not already in the view model.
/// 
/// This view handles the async loading of goal data and displays:
/// - A loading indicator while fetching
/// - The goal detail view once loaded
/// - An error state if the goal cannot be found
struct GoalDetailLoader: View {
    /// The ID of the goal to load
    let goalId: String
    /// Service for fetching goal data
    let goalService: GoalServiceProtocol
    /// The goal view model that may already contain the goal
    let goalViewModel: Benefit.GoalViewModel
    /// The loaded goal, if found
    @State private var goal: Benefit.Goal?
    /// Loading state flag
    @State private var isLoading = true
    /// Error encountered during loading, if any
    @State private var error: Error?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading goal...")
            } else if let goal = goal {
                Benefit.GoalDetailView(goal: goal)
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
