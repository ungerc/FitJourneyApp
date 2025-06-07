import Foundation
import Networking
import Authentication
import FitnessTracker

// Adapter to make NetworkServiceProtocol conform to AuthNetworkService and FitnessNetworkService
extension NetworkManager: @retroactive AuthNetworkService, @retroactive FitnessNetworkService {
}

// Adapter to make AuthServiceProtocol conform to FitnessAuthService
extension AuthManager: @retroactive FitnessAuthService {}

/// Factory class for creating application services and adapters.
/// Provides a clean interface for the app to access all services.
public class ApplicationServiceFactory {
    /// The underlying service provider
    private let serviceProvider: ServiceProvider

    /// Creates a new ApplicationServiceFactory with default services.
    public init() {
        self.serviceProvider = ServiceProvider()
    }

    /// Creates a new ApplicationServiceFactory with a custom service provider.
    /// This is primarily used for testing with mock services.
    /// - Parameter serviceProvider: Custom service provider instance
    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
    
    // MARK: - Service Creation Methods
    
    /// Creates or returns the authentication adapter.
    /// - Returns: An authentication adapter instance
    public func makeAuthAdapter() -> ApplicationAuthAdapter {
        return serviceProvider.authAdapter
    }

    /// Creates or returns the workout adapter.
    /// - Returns: A workout adapter instance
    public func makeWorkoutAdapter() -> ApplicationWorkoutAdapter {
        return serviceProvider.workoutAdapter
    }

    /// Creates or returns the goal adapter.
    /// - Returns: A goal adapter instance
    public func makeGoalAdapter() -> ApplicationGoalAdapter {
        return serviceProvider.goalAdapter
    }

    /// Creates or returns the network adapter.
    /// - Returns: A network adapter instance
    public func makeNetworkAdapter() -> ApplicationNetworkAdapter {
        return serviceProvider.networkAdapter
    }
}
