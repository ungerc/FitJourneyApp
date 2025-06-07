import Foundation
import Authentication
import FitnessTracker

// Re-export models from domain modules
public typealias User = Authentication.AuthUser
public typealias AuthError = Authentication.AuthError
public typealias Workout = FitnessTracker.Workout
public typealias WorkoutType = FitnessTracker.WorkoutType
public typealias Goal = FitnessTracker.Goal
public typealias GoalType = FitnessTracker.GoalType
