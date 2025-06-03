import Foundation
import SwiftUI

@Observable
@MainActor
class WorkoutViewModel {
    private var workoutService: WorkoutService?
    
    var workouts: [Workout] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    func initialize(workoutService: WorkoutService) {
        self.workoutService = workoutService
    }
    
    func fetchWorkouts() async {
        guard let workoutService = workoutService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            workouts = try await workoutService.fetchWorkouts()
        } catch {
            errorMessage = "Failed to fetch workouts: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addWorkout(name: String, type: WorkoutType, duration: TimeInterval, caloriesBurned: Double, date: Date) async {
        guard let workoutService = workoutService else { return }
        
        isLoading = true
        errorMessage = nil
        
        let workout = Workout(
            id: UUID().uuidString,
            name: name,
            duration: duration,
            caloriesBurned: caloriesBurned,
            date: date,
            type: type
        )
        
        do {
            let newWorkout = try await workoutService.addWorkout(workout)
            workouts.append(newWorkout)
            workouts.sort { $0.date > $1.date }
        } catch {
            errorMessage = "Failed to add workout: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func deleteWorkout(id: String) async {
        guard let workoutService = workoutService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await workoutService.deleteWorkout(id: id)
            workouts.removeAll { $0.id == id }
        } catch {
            errorMessage = "Failed to delete workout: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // Helper computed properties
    var totalCaloriesBurned: Double {
        workouts.reduce(0) { $0 + $1.caloriesBurned }
    }
    
    var totalWorkoutDuration: TimeInterval {
        workouts.reduce(0) { $0 + $1.duration }
    }
    
    var workoutsByType: [WorkoutType: [Workout]] {
        Dictionary(grouping: workouts) { $0.type }
    }
}
