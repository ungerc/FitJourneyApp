import SwiftUI
import AppCore

struct MainTabView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    var workoutViewModel: WorkoutViewModel
    var goalViewModel: GoalViewModel

    init(workoutViewModel: WorkoutViewModel, goalViewModel: GoalViewModel) {
        self.workoutViewModel = workoutViewModel
        self.goalViewModel = goalViewModel
    }
    
    var body: some View {
        @Bindable var authViewModel = authViewModel
        TabView {
            Text("Dashboard")
                .environment(workoutViewModel)
                .environment(goalViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
            
            Text("Workouts")
                .environment(workoutViewModel)
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
            
            Text("Goals")
                .environment(goalViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .fullScreenCover(isPresented: $authViewModel.needsAuthentication) {
            AuthView()
                .environment(authViewModel)
        }
        .task {
            async let workouts = workoutViewModel.fetchWorkouts
            async let goals = goalViewModel.fetchGoals
            _ = await (workouts, goals)
        }
    }
}

#Preview {
    let serviceProvider = ServiceProvider()
    
    return MainTabView(
        workoutViewModel: WorkoutViewModel(workoutAdapter: serviceProvider.workoutAdapter),
        goalViewModel: GoalViewModel(goalAdapter: serviceProvider.goalAdapter)
    )
    .environment(AuthViewModel(authAdapter: serviceProvider.authAdapter))
}
