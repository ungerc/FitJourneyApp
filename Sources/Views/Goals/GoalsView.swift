import SwiftUI

struct GoalsView: View {
    @Environment(GoalViewModel.self) private var goalViewModel
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationView {
            List {
                if goalViewModel.goals.isEmpty {
                    Text("No goals set yet")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    Section(header: Text("In Progress")) {
                        ForEach(goalViewModel.inProgressGoals) { goal in
                            NavigationLink(destination: GoalDetailView(goal: goal)) {
                                GoalRow(goal: goal)
                            }
                        }
                    }
                    
                    if !goalViewModel.completedGoals.isEmpty {
                        Section(header: Text("Completed")) {
                            ForEach(goalViewModel.completedGoals) { goal in
                                NavigationLink(destination: GoalDetailView(goal: goal)) {
                                    GoalRow(goal: goal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddGoal = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
                    .environmentObject(goalViewModel)
            }
            .refreshable {
                await goalViewModel.fetchGoals()
            }
            .overlay {
                if goalViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

struct GoalRow: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: goal.type.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
                
                Text(goal.name)
                    .font(.headline)
                
                Spacer()
                
                if goal.progress >= 1.0 {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
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
        .padding(.vertical, 4)
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

struct GoalProgressCard: View {
    let goal: Goal
    
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
        .background(Color(.systemGray6))
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

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let networkManager = NetworkManager()
        let authManager = AuthManager(networkManager: networkManager)
        let goalService = GoalService(networkManager: networkManager, authManager: authManager)
        
        GoalsView()
            .environmentObject(GoalViewModel(goalService: goalService))
    }
}
