import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GoalViewModel.self) private var goalViewModel

    @State private var name = ""
    @State private var goalType = GoalType.workouts
    @State private var targetValue = 10.0
    @State private var unit = "workouts"
    @State private var hasDeadline = false
    @State private var deadline = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Name", text: $name)
                    
                    Picker("Type", selection: $goalType) {
                        ForEach(GoalType.allCases, id: \.self) { type in
                            Label(
                                type.rawValue.capitalized,
                                systemImage: type.icon
                            ).tag(type)
                        }
                    }
                    .onChange(of: goalType) { _, newValue in
                        updateUnitForType(newValue)
                    }
                }
                
                Section(header: Text("Target")) {
                    VStack {
                        Slider(
                            value: $targetValue,
                            in: getSliderRange(),
                            step: getSliderStep()
                        )
                        
                        Text("Target: \(formatTargetValue()) \(unit)")
                            .font(.headline)
                    }
                }
                
                Section(header: Text("Deadline")) {
                    Toggle("Set Deadline", isOn: $hasDeadline)
                    
                    if hasDeadline {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveGoal()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func updateUnitForType(_ type: GoalType) {
        switch type {
        case .weight:
            unit = "kg"
            targetValue = 5.0
        case .steps:
            unit = "steps"
            targetValue = 10000
        case .workouts:
            unit = "workouts"
            targetValue = 10
        case .distance:
            unit = "km"
            targetValue = 50
        case .calories:
            unit = "calories"
            targetValue = 5000
        }
    }
    
    private func getSliderRange() -> ClosedRange<Double> {
        switch goalType {
        case .weight:
            return 1...50
        case .steps:
            return 1000...30000
        case .workouts:
            return 1...30
        case .distance:
            return 1...200
        case .calories:
            return 500...10000
        }
    }
    
    private func getSliderStep() -> Double {
        switch goalType {
        case .weight:
            return 0.5
        case .steps:
            return 1000
        case .workouts:
            return 1
        case .distance:
            return 5
        case .calories:
            return 100
        }
    }
    
    private func formatTargetValue() -> String {
        switch goalType {
        case .weight:
            return String(format: "%.1f", targetValue)
        default:
            return "\(Int(targetValue))"
        }
    }
    
    private func saveGoal() {
        let newGoal = Goal(
            id: UUID().uuidString,
            name: name,
            targetValue: targetValue,
            currentValue: 0,
            unit: unit,
            deadline: hasDeadline ? deadline : nil,
            type: goalType
        )
        
        Task {
            await goalViewModel.addGoal(newGoal)
            dismiss()
        }
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        let networkManager = NetworkManager()
        let authManager = AuthManager(networkManager: networkManager)
        let goalService = GoalService(networkManager: networkManager, authManager: authManager)
        
        AddGoalView()
            .environmentObject(GoalViewModel(goalService: goalService))
    }
}
