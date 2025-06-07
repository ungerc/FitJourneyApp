import Foundation
import SwiftUI
import Networking
import Authentication
import FitnessTracker

// MARK: - Concrete Network Adapter
internal class ConcreteNetworkAdapter: ApplicationNetworkAdapter {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetch<T: Decodable>(from urlString: String) async throws -> T {
        return try await networkService.fetch(from: urlString)
    }
    
    func post<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        return try await networkService.post(to: urlString, body: body)
    }
    
    func put<T: Encodable, U: Decodable>(to urlString: String, body: T) async throws -> U {
        return try await networkService.put(to: urlString, body: body)
    }
    
    func delete(from urlString: String) async throws {
        try await networkService.delete(from: urlString)
    }
}

// MARK: - Concrete Auth Adapter
internal class ConcreteAuthAdapter: ApplicationAuthAdapter {
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    var isAuthenticated: Bool {
        return authService.isAuthenticated
    }
    
    var currentUser: AppUser? {
        guard let authUser = authService.currentUser else { return nil }
        return AppUser(authUser: authUser)
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws -> AppUser {
        let credentials = AuthCredentials(email: email, password: password)
        let authUser = try await authService.signIn(with: credentials)
        return AppUser(authUser: authUser)
    }
    
    @MainActor
    func signUp(email: String, password: String, name: String) async throws -> AppUser {
        let credentials = AuthCredentials(email: email, password: password)
        let authUser = try await authService.signUp(with: credentials, name: name)
        return AppUser(authUser: authUser)
    }
    
    func signOut() throws {
        try authService.signOut()
    }
    
    func getToken() throws -> String {
        return try authService.getToken()
    }
    
    @MainActor
    func makeAuthView() -> AnyView {
        AnyView(
            AuthView()
                .environment(AuthViewModel(authService: authService))
        )
    }
}

// MARK: - Concrete Workout Adapter
internal class ConcreteWorkoutAdapter: ApplicationWorkoutAdapter {
    private let workoutService: WorkoutServiceProtocol
    private var _workoutViewModel: FitnessTracker.WorkoutViewModel?
    
    init(workoutService: WorkoutServiceProtocol) {
        self.workoutService = workoutService
    }

    @MainActor
    func fetchWorkouts() async throws -> [AppWorkout] {
        let fitnessWorkouts = try await workoutService.fetchWorkouts()
        return fitnessWorkouts.map { AppWorkout(workout: $0) }
    }

    @MainActor
    func addWorkout(name: String,
                           type: AppWorkoutType,
                           duration: TimeInterval,
                           caloriesBurned: Double,
                           date: Date) async throws -> AppWorkout {

        // Convert AppWorkoutType to FitnessTracker.WorkoutType
        let fitnessType: FitnessTracker.WorkoutType

        switch type {
        case .running: fitnessType = .running
        case .cycling: fitnessType = .cycling
        case .swimming: fitnessType = .swimming
        case .weightLifting: fitnessType = .weightLifting
        case .yoga: fitnessType = .yoga
        case .hiit: fitnessType = .hiit
        }
        
        let workout = FitnessTracker.Workout(
            id: UUID().uuidString, // This will be replaced by the server
            name: name,
            duration: duration,
            caloriesBurned: caloriesBurned,
            date: date,
            type: fitnessType
        )
        
        let result = try await workoutService.addWorkout(workout)
        return AppWorkout(workout: result)
    }

    @MainActor
    func deleteWorkout(id: String) async throws {
        try await workoutService.deleteWorkout(id: id)
    }
    
    @MainActor
    func makeWorkoutsView() -> AnyView {
        AnyView(
            FitnessTracker.WorkoutsView()
                .environment(makeWorkoutViewModel())
        )
    }
    
    @MainActor
    func makeWorkoutDetailView(for workoutId: String) -> AnyView {
        let viewModel = makeWorkoutViewModel()
        
        // Find the workout in the view model's workouts array
        if let workout = viewModel.workouts.first(where: { $0.id == workoutId }) {
            return AnyView(
                FitnessTracker.WorkoutDetailView(workout: workout)
            )
        } else {
            // Return a loading view that will fetch the workout
            return AnyView(
                WorkoutDetailLoader(workoutId: workoutId, workoutService: workoutService, workoutViewModel: viewModel)
            )
        }
    }
    
    @MainActor
    func makeWorkoutViewModel() -> FitnessTracker.WorkoutViewModel {
        if _workoutViewModel == nil {
            _workoutViewModel = FitnessTracker.WorkoutViewModel(workoutService: workoutService)
        }
        return _workoutViewModel!
    }
}


// MARK: - Concrete Goal Adapter
internal class ConcreteGoalAdapter: ApplicationGoalAdapter {
    private let goalService: GoalServiceProtocol
    private var _goalViewModel: FitnessTracker.GoalViewModel?
    
    init(goalService: GoalServiceProtocol) {
        self.goalService = goalService
    }

    @MainActor
    func fetchGoals() async throws -> [AppGoal] {
        let fitnessGoals = try await goalService.fetchGoals()
        return fitnessGoals.map { AppGoal(goal: $0) }
    }

    @MainActor
    func addGoal(name: String, type: AppGoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async throws -> AppGoal {
        // Convert AppGoalType to FitnessTracker.GoalType
        let fitnessType: FitnessTracker.GoalType
        switch type {
        case .weight: fitnessType = .weight
        case .steps: fitnessType = .steps
        case .workouts: fitnessType = .workouts
        case .distance: fitnessType = .distance
        case .calories: fitnessType = .calories
        }
        
        let goal = FitnessTracker.Goal(
            id: UUID().uuidString, // This will be replaced by the server
            name: name,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadline: deadline,
            type: fitnessType
        )
        
        let result = try await goalService.addGoal(goal)
        return AppGoal(goal: result)
    }

    @MainActor
    func updateGoalProgress(id: String, newValue: Double) async throws -> AppGoal {
        let updatedGoal = try await goalService.updateGoalProgress(id: id, newValue: newValue)
        return AppGoal(goal: updatedGoal)
    }

    @MainActor
    func deleteGoal(id: String) async throws {
        try await goalService.deleteGoal(id: id)
    }
    
    @MainActor
    func makeGoalsView() -> AnyView {
        AnyView(
            FitnessTracker.GoalsView()
                .environment(makeGoalViewModel())
        )
    }
    
    @MainActor
    func makeGoalDetailView(for goalId: String) -> AnyView {
        let viewModel = makeGoalViewModel()
        
        // Find the goal in the view model's goals array
        if let goal = viewModel.goals.first(where: { $0.id == goalId }) {
            return AnyView(
                FitnessTracker.GoalDetailView(goal: goal)
                    .environment(viewModel)
            )
        } else {
            // Return a loading view that will fetch the goal
            return AnyView(
                GoalDetailLoader(goalId: goalId, goalService: goalService, goalViewModel: viewModel)
            )
        }
    }
    
    @MainActor
    func makeAddGoalView() -> AnyView {
        AnyView(
            FitnessTracker.AddGoalView()
                .environment(makeGoalViewModel())
        )
    }
    
    @MainActor
    func makeGoalViewModel() -> FitnessTracker.GoalViewModel {
        if _goalViewModel == nil {
            _goalViewModel = FitnessTracker.GoalViewModel(goalService: goalService)
        }
        return _goalViewModel!
    }
}

