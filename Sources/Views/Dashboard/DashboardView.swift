import SwiftUI

struct DashboardView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    @State private var workouts: [AppWorkout] = []
    @State private var goals: [AppGoal] = []
    @State private var isLoading = false
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Summary cards
                    HStack(spacing: 15) {
                        SummaryCard(
                            title: "Workouts",
                            value: "\(workouts.count)",
                            icon: "figure.run",
                            color: .blue
                        )
                        
                        SummaryCard(
                            title: "Calories",
                            value: "\(Int(totalCaloriesBurned))",
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
                        
                        if workouts.isEmpty {
                            EmptyStateView(
                                message: "No workouts yet",
                                systemImage: "figure.run"
                            )
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(workouts.prefix(3)) { workout in
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
                        
                        if goals.isEmpty {
                            EmptyStateView(
                                message: "No goals set",
                                systemImage: "target"
                            )
                        } else {
                            VStack(spacing: 15) {
                                ForEach(inProgressGoals.prefix(3)) { goal in
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
            .task {
                await loadData()
            }
            .refreshable {
                await loadData()
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    private var totalCaloriesBurned: Double {
        workouts.reduce(0) { $0 + $1.caloriesBurned }
    }
    
    private var inProgressGoals: [AppGoal] {
        goals.filter { $0.progress < 1.0 }
    }
    
    private func loadData() async {
        isLoading = true
        
        async let workoutsResult = try? await workoutAdapter.fetchWorkouts()
        async let goalsResult = try? await goalAdapter.fetchGoals()
        
        workouts = (await workoutsResult) ?? []
        goals = (await goalsResult) ?? []
        
        isLoading = false
    }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    let workout: AppWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: workout.type.icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Spacer()
                
                Text(workout.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(workout.name)
                .font(.headline)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(formatDuration(workout.duration))
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(workout.caloriesBurned))")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Goal Progress Card
struct GoalProgressCard: View {
    let goal: AppGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: goal.type.icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Text(goal.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(goal.progress * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(progressColor)
            }
            
            ProgressView(value: goal.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
            
            HStack {
                Text("\(Int(goal.currentValue)) / \(Int(goal.targetValue)) \(goal.unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let deadline = goal.deadline {
                    Text(deadline, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var progressColor: Color {
        if goal.progress >= 1.0 {
            return .green
        } else if goal.progress >= 0.7 {
            return .blue
        } else if goal.progress >= 0.3 {
            return .orange
        } else {
            return .red
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
        .background(Color.gray.opacity(0.1))
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

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let networkManager = NetworkManager()
//        let authManager = AuthManager(networkManager: networkManager)
//        let workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
//        let goalService = GoalService(networkManager: networkManager, authManager: authManager)
//        
//        DashboardView()
//            .environmentObject(WorkoutViewModel(workoutService: workoutService))
//            .environmentObject(GoalViewModel(goalService: goalService))
//    }
//}
