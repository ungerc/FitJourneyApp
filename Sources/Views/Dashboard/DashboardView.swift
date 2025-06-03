import SwiftUI
import FitnessTracker

struct DashboardView: View {
    @Environment(WorkoutViewModel.self) private var workoutViewModel
    @Environment(GoalViewModel.self) private var goalViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Summary cards
                    HStack(spacing: 15) {
                        SummaryCard(
                            title: "Workouts",
                            value: "\(workoutViewModel.workouts.count)",
                            icon: "figure.run",
                            color: .blue
                        )
                        
                        SummaryCard(
                            title: "Calories",
                            value: "\(Int(workoutViewModel.totalCaloriesBurned))",
                            icon: "flame",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    // Recent workouts
                    VStack(alignment: .leading) {
                        Text("Recent Workouts")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if workoutViewModel.workouts.isEmpty {
                            EmptyStateView(
                                message: "No workouts yet",
                                systemImage: "figure.run"
                            )
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(workoutViewModel.workouts.prefix(3)) { workout in
                                        WorkoutCard(workout: workout)
                                            .frame(width: 250)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Goals progress
                    VStack(alignment: .leading) {
                        Text("Goals Progress")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if goalViewModel.goals.isEmpty {
                            EmptyStateView(
                                message: "No goals set",
                                systemImage: "target"
                            )
                        } else {
                            VStack(spacing: 15) {
                                ForEach(goalViewModel.inProgressGoals.prefix(3)) { goal in
                                    GoalProgressCard(goal: goal)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await workoutViewModel.fetchWorkouts()
                await goalViewModel.fetchGoals()
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}

struct EmptyStateView: View {
    let message: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let networkManager = NetworkManager()
        let authManager = AuthManager(networkManager: networkManager)
        let workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
        let goalService = GoalService(networkManager: networkManager, authManager: authManager)
        
        DashboardView()
            .environmentObject(WorkoutViewModel(workoutService: workoutService))
            .environmentObject(GoalViewModel(goalService: goalService))
    }
}
