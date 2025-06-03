import SwiftUI
import AppCore

// Main tab view for the authenticated user
struct MainTabView: View {
    @Environment(WorkoutViewModel.self) private var workoutViewModel
    @Environment(GoalViewModel.self) private var goalViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var showConfetti = false

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
        .onAppear {
            // Load data when tab view appears
            Task {
                await workoutViewModel.fetchWorkouts()
                await goalViewModel.fetchGoals()
            }
            
            // Show confetti when the tab view appears after login
            showConfetti = true
            
            // Hide confetti after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showConfetti = false
            }
        }
        .overlay {
            ConfettiView(isShowing: $showConfetti)
        }
    }
}
