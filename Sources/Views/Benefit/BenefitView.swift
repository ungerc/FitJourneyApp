import SwiftUI

/// Combined view for workouts and goals with navigation interface.
/// Provides a unified experience for tracking fitness benefits.
internal struct BenefitView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: workoutAdapter.makeWorkoutsView()) {
                        HStack {
                            Image(systemName: "figure.run")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Workouts")
                                    .font(.headline)
                                Text("Track your exercise sessions")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: goalAdapter.makeGoalsView()) {
                        HStack {
                            Image(systemName: "target")
                                .font(.title2)
                                .foregroundColor(.green)
                                .frame(width: 40, height: 40)
                                .background(Color.green.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Goals")
                                    .font(.headline)
                                Text("Set and track your fitness goals")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Quick Stats")) {
                    QuickStatsView(goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                }
            }
            .navigationTitle("Benefit")
        }
    }
}

/// Quick stats view showing summary of workouts and goals
private struct QuickStatsView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    @State private var workoutCount = 0
    @State private var activeGoalsCount = 0
    @State private var completedGoalsCount = 0
    @State private var isLoading = true
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                StatItem(
                    title: "Total Workouts",
                    value: "\(workoutCount)",
                    icon: "figure.run",
                    color: .blue
                )
                
                Spacer()
                
                StatItem(
                    title: "Active Goals",
                    value: "\(activeGoalsCount)",
                    icon: "target",
                    color: .orange
                )
                
                Spacer()
                
                StatItem(
                    title: "Completed",
                    value: "\(completedGoalsCount)",
                    icon: "checkmark.circle",
                    color: .green
                )
            }
        }
        .padding(.vertical, 8)
        .task {
            await loadStats()
        }
        .overlay {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }
    
    @MainActor
    private func loadStats() async {
        isLoading = true
        
        // Fetch workouts
        if let workouts = try? await workoutAdapter.fetchWorkouts() {
            workoutCount = workouts.count
        }
        
        // Fetch goals
        if let goals = try? await goalAdapter.fetchGoals() {
            activeGoalsCount = goals.filter { $0.progress < 1.0 }.count
            completedGoalsCount = goals.filter { $0.progress >= 1.0 }.count
        }
        
        isLoading = false
    }
}

private struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
