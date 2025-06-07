import Foundation
import SwiftUI
import Networking
import Authentication
import FitnessTracker

// MARK: - Auth Adapter Protocol
/// Protocol for authentication adapters in the application layer.
/// Bridges between the domain authentication services and the UI layer.
public protocol ApplicationAuthAdapter: AnyObject {
    /// Indicates whether a user is currently authenticated
    var isAuthenticated: Bool { get }
    
    /// The currently authenticated user, if any
    var currentUser: AppUser? { get }
    
    /// Signs in a user with email and password.
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: The authenticated user
    /// - Throws: Authentication errors
    @MainActor
    func signIn(email: String, password: String) async throws -> AppUser
    
    /// Creates a new user account and signs them in.
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - name: User's display name
    /// - Returns: The newly created and authenticated user
    /// - Throws: Authentication errors
    @MainActor
    func signUp(email: String, password: String, name: String) async throws -> AppUser
    
    /// Signs out the current user.
    /// - Throws: Sign out errors
    func signOut() throws
    
    /// Retrieves the authentication token.
    /// - Returns: The authentication token
    /// - Throws: Errors if no valid token is available
    func getToken() throws -> String
    
    /// Creates the authentication view for the UI.
    /// - Returns: A type-erased view for authentication
    @MainActor
    func makeAuthView() -> AnyView
}

// MARK: - Workout Adapter Protocol
/// Protocol for workout adapters in the application layer.
/// Bridges between the domain workout services and the UI layer.
public protocol ApplicationWorkoutAdapter {
    /// Fetches all workouts for the current user.
    /// - Returns: Array of app-specific workout models
    /// - Throws: Network or authentication errors
    func fetchWorkouts() async throws -> [AppWorkout]
    
    /// Adds a new workout.
    /// - Parameters:
    ///   - name: Name of the workout
    ///   - type: Type of workout activity
    ///   - duration: Duration in seconds
    ///   - caloriesBurned: Estimated calories burned
    ///   - date: Date and time of the workout
    /// - Returns: The created workout
    /// - Throws: Network or authentication errors
    func addWorkout(name: String, type: AppWorkoutType, duration: TimeInterval, caloriesBurned: Double, date: Date) async throws -> AppWorkout
    
    /// Deletes a workout by ID.
    /// - Parameter id: The workout's unique identifier
    /// - Throws: Network or authentication errors
    func deleteWorkout(id: String) async throws
    
    /// Creates the workouts view for the UI.
    /// - Returns: A type-erased view for workouts
    @MainActor
    func makeWorkoutsView() -> AnyView
    
    /// Creates a workout detail view for the specified workout ID.
    /// - Parameter workoutId: The ID of the workout to display
    /// - Returns: A type-erased view for the workout detail
    @MainActor
    func makeWorkoutDetailView(for workoutId: String) -> AnyView
    
    /// Creates or returns the workout view model.
    /// - Returns: The workout view model instance
    @MainActor
    func makeWorkoutViewModel() -> FitnessTracker.WorkoutViewModel
}

// MARK: - Goal Adapter Protocol
/// Protocol for goal adapters in the application layer.
/// Bridges between the domain goal services and the UI layer.
public protocol ApplicationGoalAdapter {
    /// Fetches all goals for the current user.
    /// - Returns: Array of app-specific goal models
    /// - Throws: Network or authentication errors
    func fetchGoals() async throws -> [AppGoal]
    
    /// Adds a new goal.
    /// - Parameters:
    ///   - name: Name of the goal
    ///   - type: Type of goal
    ///   - targetValue: Target value to achieve
    ///   - currentValue: Current progress value
    ///   - unit: Unit of measurement
    ///   - deadline: Optional deadline date
    /// - Returns: The created goal
    /// - Throws: Network or authentication errors
    func addGoal(name: String, type: AppGoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async throws -> AppGoal
    
    /// Updates the progress of a goal.
    /// - Parameters:
    ///   - id: The goal's unique identifier
    ///   - newValue: The new progress value
    /// - Returns: The updated goal
    /// - Throws: Network or authentication errors
    func updateGoalProgress(id: String, newValue: Double) async throws -> AppGoal
    
    /// Deletes a goal by ID.
    /// - Parameter id: The goal's unique identifier
    /// - Throws: Network or authentication errors
    func deleteGoal(id: String) async throws
    
    /// Creates the goals view for the UI.
    /// - Returns: A type-erased view for goals
    @MainActor
    func makeGoalsView() -> AnyView
    
    /// Creates a goal detail view for the specified goal ID.
    /// - Parameter goalId: The ID of the goal to display
    /// - Returns: A type-erased view for the goal detail
    @MainActor
    func makeGoalDetailView(for goalId: String) -> AnyView
    
    /// Creates the add goal view for the UI.
    /// - Returns: A type-erased view for adding a new goal
    @MainActor
    func makeAddGoalView() -> AnyView
    
    /// Creates or returns the goal view model.
    /// - Returns: The goal view model instance
    @MainActor
    func makeGoalViewModel() -> FitnessTracker.GoalViewModel
}

// MARK: - Network Adapter Protocol
/// Protocol for network adapters in the application layer.
/// Provides a simplified interface for network operations.
public protocol ApplicationNetworkAdapter {
    /// Fetches and decodes data from a URL.
    /// - Parameter urlString: The URL to fetch from
    /// - Returns: Decoded data of type T
    /// - Throws: Network or decoding errors
    func fetch<T: Decodable>(from urlString: String) async throws -> T
    
    /// Sends a POST request with encoded data.
    /// - Parameters:
    ///   - urlString: The URL to post to
    ///   - body: Data to encode and send
    /// - Returns: Decoded response of type U
    /// - Throws: Network or encoding/decoding errors
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    
    /// Sends a PUT request with encoded data.
    /// - Parameters:
    ///   - urlString: The URL to put to
    ///   - body: Data to encode and send
    /// - Returns: Decoded response of type U
    /// - Throws: Network or encoding/decoding errors
    func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U
    
    /// Sends a DELETE request.
    /// - Parameter urlString: The URL to delete from
    /// - Throws: Network errors
    func delete(from urlString: String) async throws
}

// MARK: - Model Types
public struct AppUser: Codable, Identifiable, Sendable {
    public let id: String
    public let email: String
    public let name: String
    
    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
    
    // Convert from AuthUser
    public init(authUser: AuthUser) {
        self.id = authUser.id
        self.email = authUser.email
        self.name = authUser.name
    }
}

public struct AppWorkout: Identifiable, Codable, Sendable {
    public let id: String
    public let name: String
    public let duration: TimeInterval
    public let caloriesBurned: Double
    public let date: Date
    public let type: AppWorkoutType
    
    public init(id: String, name: String, duration: TimeInterval, caloriesBurned: Double, date: Date, type: AppWorkoutType) {
        self.id = id
        self.name = name
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.date = date
        self.type = type
    }
    
    // Convert from FitnessTracker Workout
    public init(workout: FitnessTracker.Workout) {
        self.id = workout.id
        self.name = workout.name
        self.duration = workout.duration
        self.caloriesBurned = workout.caloriesBurned
        self.date = workout.date
        self.type = AppWorkoutType(fitnessType: workout.type)
    }
}

public enum AppWorkoutType: String, Codable, CaseIterable, Sendable {
    case running
    case cycling
    case swimming
    case weightLifting
    case yoga
    case hiit
    
    public var icon: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .weightLifting: return "dumbbell"
        case .yoga: return "figure.mind.and.body"
        case .hiit: return "heart.circle"
        }
    }
    
    // Convert from FitnessTracker WorkoutType
    public init(fitnessType: FitnessTracker.WorkoutType) {
        switch fitnessType {
        case .running: self = .running
        case .cycling: self = .cycling
        case .swimming: self = .swimming
        case .weightLifting: self = .weightLifting
        case .yoga: self = .yoga
        case .hiit: self = .hiit
        }
    }
}

public struct AppGoal: Identifiable, Codable, Sendable {
    public let id: String
    public let name: String
    public let targetValue: Double
    public let currentValue: Double
    public let unit: String
    public let deadline: Date?
    public let type: AppGoalType
    
    public var progress: Double {
        return min(currentValue / targetValue, 1.0)
    }
    
    public init(id: String, name: String, targetValue: Double, currentValue: Double, unit: String, deadline: Date?, type: AppGoalType) {
        self.id = id
        self.name = name
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.deadline = deadline
        self.type = type
    }
    
    // Convert from FitnessTracker Goal
    public init(goal: FitnessTracker.Goal) {
        self.id = goal.id
        self.name = goal.name
        self.targetValue = goal.targetValue
        self.currentValue = goal.currentValue
        self.unit = goal.unit
        self.deadline = goal.deadline
        self.type = AppGoalType(fitnessType: goal.type)
    }
}

public enum AppGoalType: String, Codable, CaseIterable, Sendable {
    case weight
    case steps
    case workouts
    case distance
    case calories
    
    public var icon: String {
        switch self {
        case .weight: return "scalemass"
        case .steps: return "figure.walk"
        case .workouts: return "figure.highintensity.intervaltraining"
        case .distance: return "figure.run"
        case .calories: return "flame"
        }
    }
    
    // Convert from FitnessTracker GoalType
    public init(fitnessType: FitnessTracker.GoalType) {
        switch fitnessType {
        case .weight: self = .weight
        case .steps: self = .steps
        case .workouts: self = .workouts
        case .distance: self = .distance
        case .calories: self = .calories
        }
    }
}
