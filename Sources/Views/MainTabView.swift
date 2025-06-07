import SwiftUI

// Main tab view for the authenticated user
internal struct MainTabView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }

    var body: some View {
        TabView {
            DashboardView(goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }

            workoutAdapter.makeWorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }

            goalAdapter.makeGoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
