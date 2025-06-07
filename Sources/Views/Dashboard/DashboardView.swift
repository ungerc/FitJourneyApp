import SwiftUI

struct DashboardView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    @State private var workouts: [AppWorkout] = []
    @State private var goals: [AppGoal] = []
    @State private var isLoading = false
    @Environment(NavigationRouter.self) private var navigationRouter
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Summary cards
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            SummaryCard(
                                title: "Total Workouts",
                                value: "\(workouts.count)",
                                icon: "figure.run",
                                color: .blue
                            )
                            
                            SummaryCard(
                                title: "This Week",
                                value: "\(weeklyWorkoutCount)",
                                icon: "calendar",
                                color: .green
                            )
                        }
                        
                        HStack(spacing: 15) {
                            SummaryCard(
                                title: "Calories Burned",
                                value: "\(Int(totalCaloriesBurned))",
                                icon: "flame",
                                color: .orange
                            )
                            
                            if inProgressGoals.isEmpty && !goals.isEmpty {
                                SummaryCard(
                                    title: "Goals Completed",
                                    value: "\(goals.count)",
                                    icon: "trophy.fill",
                                    color: .yellow
                                )
                            } else {
                                SummaryCard(
                                    title: "Active Goals",
                                    value: "\(inProgressGoals.count)",
                                    icon: "target",
                                    color: .purple
                                )
                            }
                        }
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
                                    ForEach(recentWorkouts) { workout in
                                        WorkoutCard(workout: workout)
                                            .frame(width: 250)
                                            .onTapGesture {
                                                navigateToWorkout(workout.id)
                                            }
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
                        } else if inProgressGoals.isEmpty && !goals.isEmpty {
                            // All goals completed
                            CompletedGoalsView(completedCount: goals.count)
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 15) {
                                ForEach(inProgressGoals.prefix(3)) { goal in
                                    GoalProgressCard(goal: goal)
                                        .onTapGesture {
                                            navigateToGoal(goal.id)
                                        }
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
    
    private var recentWorkouts: [AppWorkout] {
        // Sort workouts by date (most recent first) and take the first 3
        workouts.sorted { $0.date > $1.date }.prefix(3).map { $0 }
    }
    
    private var weeklyWorkoutCount: Int {
        // Count workouts from the last 7 days
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return workouts.filter { $0.date >= oneWeekAgo }.count
    }
    
    private func loadData() async {
        isLoading = true
        
        async let workoutsResult = try? await workoutAdapter.fetchWorkouts()
        async let goalsResult = try? await goalAdapter.fetchGoals()
        
        workouts = (await workoutsResult) ?? []
        goals = (await goalsResult) ?? []
        
        isLoading = false
    }
    
    private func navigateToWorkout(_ workoutId: String) {
        navigationRouter.navigate(to: .workoutDetail(workoutId: workoutId))
    }
    
    private func navigateToGoal(_ goalId: String) {
        navigationRouter.navigate(to: .goalDetail(goalId: goalId))
    }
}

