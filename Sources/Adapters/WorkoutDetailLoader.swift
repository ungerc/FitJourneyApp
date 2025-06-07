import SwiftUI
import FitnessTracker

/// Helper view that loads a workout detail when it's not already in the view model.
/// 
/// This view handles the async loading of workout data and displays:
/// - A loading indicator while fetching
/// - The workout detail view once loaded
/// - An error state if the workout cannot be found
struct WorkoutDetailLoader: View {
    /// The ID of the workout to load
    let workoutId: String
    /// Service for fetching workout data
    let workoutService: WorkoutServiceProtocol
    /// The workout view model that may already contain the workout
    let workoutViewModel: FitnessTracker.WorkoutViewModel
    /// The loaded workout, if found
    @State private var workout: FitnessTracker.Workout?
    /// Loading state flag
    @State private var isLoading = true
    /// Error encountered during loading, if any
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
