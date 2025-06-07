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

            BenefitView(goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                .tabItem {
                    Label("Benefit", systemImage: "star.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
