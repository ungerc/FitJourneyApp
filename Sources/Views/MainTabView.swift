import SwiftUI

// Main tab view for the authenticated user
internal struct MainTabView: View {
    @Environment(WorkoutViewModel.self) private var workoutViewModel
    @Environment(GoalViewModel.self) private var goalViewModel

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }

            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }

            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .task {
            // Load data when tab view appears
            await workoutViewModel.fetchWorkouts()
            await goalViewModel.fetchGoals()
        }
    }
}
