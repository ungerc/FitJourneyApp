import SwiftUI
import AppCore

struct GoalDetailView: View {
    let goal: AppGoal
    @State private var updatedValue: Double
    @Environment(GoalViewModel.self) private var goalViewModel

    init(goal: AppGoal) {
        self.goal = goal
        self._updatedValue = State(initialValue: goal.currentValue)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: goal.type.icon)
                            .foregroundColor(.blue)
                        
                        Text(goal.type.rawValue.capitalized)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Progress
                VStack(alignment: .leading, spacing: 10) {
                    Text("Progress")
                        .font(.headline)
                    
                    ProgressView(value: goal.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                    
                    HStack {
                        Text("\(Int(goal.currentValue)) / \(Int(goal.targetValue)) \(goal.unit)")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(Int(goal.progress * 100))%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(progressColor)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Deadline
                if let deadline = goal.deadline {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Deadline")
                            .font(.headline)
                        
                        Text(deadline, style: .date)
                            .font(.subheadline)
                        
                        let daysRemaining = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day ?? 0
                        
                        if daysRemaining > 0 {
                            Text("\(daysRemaining) days remaining")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if daysRemaining == 0 {
                            Text("Due today")
                                .font(.caption)
                                .foregroundColor(.orange)
                        } else {
                            Text("Overdue by \(abs(daysRemaining)) days")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Update progress
                VStack(alignment: .leading, spacing: 10) {
                    Text("Update Progress")
                        .font(.headline)
                    
                    VStack {
                        Slider(value: $updatedValue, in: 0...goal.targetValue * 1.2, step: 1)
                        
                        HStack {
                            Text("Current Value: \(Int(updatedValue)) \(goal.unit)")
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Button("Update") {
                                updateGoalProgress()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(updatedValue == goal.currentValue)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)
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
    
    private func updateGoalProgress() {
        Task {
            await goalViewModel.updateGoalProgress(id: goal.id, newValue: updatedValue)
        }
    }
}

//struct GoalDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let networkManager = NetworkManager()
//        let authManager = AuthManager(networkManager: networkManager)
//        let goalService = GoalService(networkManager: networkManager, authManager: authManager)
//        
//        NavigationView {
//            GoalDetailView(
//                goal: Goal(
//                    id: "1",
//                    name: "Lose Weight",
//                    targetValue: 10.0,
//                    currentValue: 3.5,
//                    unit: "kg",
//                    deadline: Calendar.current.date(byAdding: .month, value: 2, to: Date()),
//                    type: .weight
//                )
//            )
//            .environmentObject(GoalViewModel(goalService: goalService))
//        }
//    }
//}
