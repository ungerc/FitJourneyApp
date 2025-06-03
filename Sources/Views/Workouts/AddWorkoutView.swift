import SwiftUI
import FitnessTracker

struct AddWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(WorkoutViewModel.self) private var workoutViewModel

    @State private var name = ""
    @State private var workoutType = WorkoutType.running
    @State private var duration = 30.0
    @State private var caloriesBurned = 200.0
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    TextField("Workout Name", text: $name)
                    
                    Picker("Type", selection: $workoutType) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            Label(
                                type.rawValue.capitalized,
                                systemImage: type.icon
                            ).tag(type)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Duration")) {
                    VStack {
                        Slider(value: $duration, in: 5...180, step: 5)
                        
                        HStack {
                            Text("Duration: \(Int(duration)) minutes")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(formatDuration(duration * 60))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Calories")) {
                    VStack {
                        Slider(value: $caloriesBurned, in: 50...1000, step: 10)
                        
                        Text("Calories Burned: \(Int(caloriesBurned))")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveWorkout() {
        let newWorkout = Workout(
            id: UUID().uuidString,
            name: name,
            duration: duration * 60, // Convert to seconds
            caloriesBurned: caloriesBurned,
            date: date,
            type: workoutType
        )
        
        Task {
            await workoutViewModel.addWorkout(newWorkout)
            dismiss()
        }
    }
    
    private func formatDuration(_ seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let networkManager = NetworkManager()
        let authManager = AuthManager(networkManager: networkManager)
        let workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
        
        AddWorkoutView()
            .environmentObject(WorkoutViewModel(workoutService: workoutService))
    }
}
