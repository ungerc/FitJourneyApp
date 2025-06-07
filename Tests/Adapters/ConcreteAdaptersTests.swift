import Testing
import SwiftUI
@testable import FitJourneyApp
@testable import Authentication
@testable import Benefit

@Suite("ConcreteAdapters Tests")
struct ConcreteAdaptersTests {
    
    // MARK: - ConcreteAuthAdapter Tests
    
    @Test("ConcreteAuthAdapter isAuthenticated delegates to service")
    func concreteAuthAdapterIsAuthenticated() {
        // Given
        let mockAuthService = MockAuthServiceForAdapter()
        mockAuthService.isAuthenticated = true
        let adapter = ConcreteAuthAdapter(authService: mockAuthService)
        
        // When
        let isAuthenticated = adapter.isAuthenticated
        
        // Then
        #expect(isAuthenticated)
    }
    
    @Test("ConcreteAuthAdapter currentUser converts from AuthUser")
    func concreteAuthAdapterCurrentUser() {
        // Given
        let mockAuthService = MockAuthServiceForAdapter()
        let authUser = AuthUser(id: "1", email: "test@example.com", name: "Test User")
        mockAuthService.currentUser = authUser
        let adapter = ConcreteAuthAdapter(authService: mockAuthService)
        
        // When
        let appUser = adapter.currentUser
        
        // Then
        #expect(appUser != nil)
        #expect(appUser?.id == authUser.id)
        #expect(appUser?.email == authUser.email)
        #expect(appUser?.name == authUser.name)
    }
    
    @Test("ConcreteAuthAdapter signIn returns AppUser")
    @MainActor
    func concreteAuthAdapterSignIn() async throws {
        // Given
        let mockAuthService = MockAuthServiceForAdapter()
        let authUser = AuthUser(id: "1", email: "test@example.com", name: "Test User")
        mockAuthService.signInResult = .success(authUser)
        let adapter = ConcreteAuthAdapter(authService: mockAuthService)
        
        // When
        let appUser = try await adapter.signIn(email: "test@example.com", password: "password")
        
        // Then
        #expect(appUser.id == authUser.id)
        #expect(appUser.email == authUser.email)
        #expect(appUser.name == authUser.name)
    }
    
    // MARK: - ConcreteWorkoutAdapter Tests
    
    @Test("ConcreteWorkoutAdapter fetchWorkouts converts to AppWorkouts")
    @MainActor
    func concreteWorkoutAdapterFetchWorkouts() async throws {
        // Given
        let mockWorkoutService = MockWorkoutServiceForAdapter()
        let fitnessWorkouts = [
            Workout(id: "1", name: "Run", duration: 1800, caloriesBurned: 300, date: Date(), type: .running)
        ]
        mockWorkoutService.fetchWorkoutsResult = .success(fitnessWorkouts)
        let adapter = ConcreteWorkoutAdapter(workoutService: mockWorkoutService)
        
        // When
        let appWorkouts = try await adapter.fetchWorkouts()
        
        // Then
        #expect(appWorkouts.count == 1)
        #expect(appWorkouts[0].id == "1")
        #expect(appWorkouts[0].name == "Run")
        #expect(appWorkouts[0].type == .running)
    }
    
    @Test("ConcreteWorkoutAdapter addWorkout converts types")
    @MainActor
    func concreteWorkoutAdapterAddWorkout() async throws {
        // Given
        let mockWorkoutService = MockWorkoutServiceForAdapter()
        let expectedWorkout = Workout(id: "2", name: "Yoga", duration: 3600, caloriesBurned: 200, date: Date(), type: .yoga)
        mockWorkoutService.addWorkoutResult = .success(expectedWorkout)
        let adapter = ConcreteWorkoutAdapter(workoutService: mockWorkoutService)
        
        // When
        let appWorkout = try await adapter.addWorkout(
            name: "Yoga",
            type: .yoga,
            duration: 3600,
            caloriesBurned: 200,
            date: Date()
        )
        
        // Then
        #expect(appWorkout.id == "2")
        #expect(appWorkout.name == "Yoga")
        #expect(appWorkout.type == .yoga)
    }
    
    // MARK: - ConcreteGoalAdapter Tests
    
    @Test("ConcreteGoalAdapter fetchGoals converts to AppGoals")
    @MainActor
    func concreteGoalAdapterFetchGoals() async throws {
        // Given
        let mockGoalService = MockGoalServiceForAdapter()
        let fitnessGoals = [
            Goal(id: "1", name: "Steps", targetValue: 10000, currentValue: 5000, unit: "steps", type: .steps)
        ]
        mockGoalService.fetchGoalsResult = .success(fitnessGoals)
        let adapter = ConcreteGoalAdapter(goalService: mockGoalService)
        
        // When
        let appGoals = try await adapter.fetchGoals()
        
        // Then
        #expect(appGoals.count == 1)
        #expect(appGoals[0].id == "1")
        #expect(appGoals[0].name == "Steps")
        #expect(appGoals[0].type == .steps)
        #expect(appGoals[0].progress == 0.5)
    }
}

// MARK: - Mock Services for Adapter Tests

class MockAuthServiceForAdapter: AuthServiceProtocol {
    var isAuthenticated: Bool = false
    var currentUser: AuthUser?
    var signInResult: Result<AuthUser, Error>?
    var signUpResult: Result<AuthUser, Error>?
    
    @MainActor
    func signIn(with credentials: AuthCredentials) async throws -> AuthUser {
        guard let result = signInResult else {
            throw AuthError.signInFailed
        }
        switch result {
        case .success(let user):
            currentUser = user
            isAuthenticated = true
            return user
        case .failure(let error):
            throw error
        }
    }
    
    @MainActor
    func signUp(with credentials: AuthCredentials, name: String) async throws -> AuthUser {
        guard let result = signUpResult else {
            throw AuthError.signUpFailed
        }
        switch result {
        case .success(let user):
            currentUser = user
            isAuthenticated = true
            return user
        case .failure(let error):
            throw error
        }
    }
    
    func signOut() throws {
        currentUser = nil
        isAuthenticated = false
    }
    
    func getToken() throws -> String {
        return "mock-token"
    }
}

@MainActor
class MockWorkoutServiceForAdapter: WorkoutServiceProtocol {
    var fetchWorkoutsResult: Result<[Workout], Error>?
    var addWorkoutResult: Result<Workout, Error>?
    var deleteWorkoutShouldSucceed = true
    var deleteWorkoutError: Error?
    
    func fetchWorkouts() async throws -> [Workout] {
        guard let result = fetchWorkoutsResult else {
            throw MockError.notImplemented
        }
        switch result {
        case .success(let workouts):
            return workouts
        case .failure(let error):
            throw error
        }
    }
    
    func addWorkout(_ workout: Workout) async throws -> Workout {
        guard let result = addWorkoutResult else {
            throw MockError.notImplemented
        }
        switch result {
        case .success(let workout):
            return workout
        case .failure(let error):
            throw error
        }
    }
    
    func deleteWorkout(id: String) async throws {
        if !deleteWorkoutShouldSucceed {
            throw deleteWorkoutError ?? MockError.networkError
        }
        // Success case - just return without throwing
    }
}

@MainActor
class MockGoalServiceForAdapter: GoalServiceProtocol {
    var fetchGoalsResult: Result<[Goal], Error>?
    var addGoalResult: Result<Goal, Error>?
    var updateGoalProgressResult: Result<Goal, Error>?
    var deleteGoalShouldSucceed = true
    var deleteGoalError: Error?
    
    func fetchGoals() async throws -> [Goal] {
        guard let result = fetchGoalsResult else {
            throw MockError.notImplemented
        }
        switch result {
        case .success(let goals):
            return goals
        case .failure(let error):
            throw error
        }
    }
    
    func addGoal(_ goal: Goal) async throws -> Goal {
        guard let result = addGoalResult else {
            throw MockError.notImplemented
        }
        switch result {
        case .success(let goal):
            return goal
        case .failure(let error):
            throw error
        }
    }
    
    func updateGoalProgress(id: String, newValue: Double) async throws -> Goal {
        guard let result = updateGoalProgressResult else {
            throw MockError.notImplemented
        }
        switch result {
        case .success(let goal):
            return goal
        case .failure(let error):
            throw error
        }
    }
    
    func deleteGoal(id: String) async throws {
        if !deleteGoalShouldSucceed {
            throw deleteGoalError ?? MockError.networkError
        }
        // Success case - just return without throwing
    }
}
