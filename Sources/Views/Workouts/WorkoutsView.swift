import SwiftUI
import struct AppCore.AppWorkout

struct WorkoutsView: View {
    @Environment(WorkoutViewModel.self) private var workoutViewModel
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView {
            List {
                if workoutViewModel.workouts.isEmpty {
                    Text("No workouts recorded yet")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(workoutViewModel.workouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            WorkoutRow(workout: workout)
                        }
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddWorkout = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
                    .environment(workoutViewModel)
            }
            .refreshable {
                await workoutViewModel.fetchWorkouts()
            }
            .overlay {
                if workoutViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

struct WorkoutRow: View {
    let workout: AppWorkout

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: workout.type.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.headline)
                
                Text(workout.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(workout.caloriesBurned)) cal")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                Text(formatDuration(workout.duration))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
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
        .background(Color(.systemGray6))
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

//struct WorkoutsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let networkManager = NetworkManager()
//        let authManager = AuthManager(networkManager: networkManager)
//        let workoutService = WorkoutService(networkManager: networkManager, authManager: authManager)
//        
//        WorkoutsView()
//            .environmentObject(WorkoutViewModel(workoutService: workoutService))
//    }
//}
