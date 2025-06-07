import Foundation
import Networking
import Authentication
import FitnessTracker

/// Central service provider that creates and manages all application services and adapters.
/// This class follows the dependency injection pattern to provide services throughout the app.
public class ServiceProvider {
    // MARK: - Application Adapters
    
    /// Network adapter for making HTTP requests
    public let networkAdapter: ApplicationNetworkAdapter
    
    /// Authentication adapter for user authentication
    public let authAdapter: ApplicationAuthAdapter
    
    /// Workout adapter for managing workout data
    public let workoutAdapter: ApplicationWorkoutAdapter
    
    /// Goal adapter for managing fitness goals
    public let goalAdapter: ApplicationGoalAdapter
    
    /// Creates a new ServiceProvider with default implementations.
    /// This initializer creates all necessary services and wires them together.
    public init() {
        // Create core services
        let networkService = NetworkManager()
        let authService = AuthManager(networkService: networkService)
        
        // Create domain services
        let workoutService = WorkoutService(networkService: networkService, authService: authService)
        let goalService = GoalService(networkService: networkService, authService: authService)
        
        // Create adapters
        self.networkAdapter = ConcreteNetworkAdapter(networkService: networkService)
        self.authAdapter = ConcreteAuthAdapter(authService: authService)
        self.workoutAdapter = ConcreteWorkoutAdapter(workoutService: workoutService)
        self.goalAdapter = ConcreteGoalAdapter(goalService: goalService)
    }
    
    /// Creates a new ServiceProvider with injected dependencies.
    /// This initializer is primarily used for testing with mock services.
    /// - Parameters:
    ///   - networkService: Network service implementation
    ///   - authService: Authentication service implementation
    ///   - workoutService: Workout service implementation
    ///   - goalService: Goal service implementation
    public init(
        networkService: NetworkServiceProtocol,
        authService: AuthServiceProtocol,
        workoutService: WorkoutServiceProtocol,
        goalService: GoalServiceProtocol
    ) {
        self.networkAdapter = ConcreteNetworkAdapter(networkService: networkService)
        self.authAdapter = ConcreteAuthAdapter(authService: authService)
        self.workoutAdapter = ConcreteWorkoutAdapter(workoutService: workoutService)
        self.goalAdapter = ConcreteGoalAdapter(goalService: goalService)
    }
}
