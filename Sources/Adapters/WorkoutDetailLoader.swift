import SwiftUI
import FitnessTracker

// Helper view to load a workout if not already in the view model
struct WorkoutDetailLoader: View {
    let workoutId: String
    let workoutService: WorkoutServiceProtocol
    let workoutViewModel: FitnessTracker.WorkoutViewModel
    @State private var workout: FitnessTracker.Workout?
    @State private var isLoading = true
    @State private var error: Error?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading workout...")
            } else if let workout = workout {
                FitnessTracker.WorkoutDetailView(workout: workout)
            } else {
                ContentUnavailableView("Workout Not Found", 
                                     systemImage: "figure.run",
                                     description: Text("The workout could not be found."))
            }
        }
        .task {
            await loadWorkout()
        }
    }
    
    private func loadWorkout() async {
        do {
            // First try to find in existing workouts
            if let existingWorkout = workoutViewModel.workouts.first(where: { $0.id == workoutId }) {
                workout = existingWorkout
            } else {
                // If not found, fetch all workouts
                let workouts = try await workoutService.fetchWorkouts()
                workout = workouts.first { $0.id == workoutId }
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
