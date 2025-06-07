import SwiftUI
import Combine

/// Navigation destinations that can be accessed from anywhere in the app
public enum NavigationDestination: Hashable {
    case workoutDetail(workoutId: String)
    case goalDetail(goalId: String)
    case profile
    case dashboard
    case goals
}

/// Router for handling programmatic navigation throughout the app
@Observable
public class NavigationRouter {
    /// The current navigation path
    public var path = NavigationPath()
    
    /// Pending destination to navigate to
    public var pendingDestination: NavigationDestination?
    
    /// Tab selection for main tab view
    public var selectedTab: Tab = .dashboard
    
    /// Navigate to a specific destination
    public func navigate(to destination: NavigationDestination) {
        // First, switch to the appropriate tab if needed
        switch destination {
        case .workoutDetail:
            selectedTab = .benefit
        case .goalDetail:
            selectedTab = .benefit
        case .goals:
            selectedTab = .benefit
        case .profile:
            selectedTab = .profile
        case .dashboard:
            selectedTab = .dashboard
        }
        
        // Set the pending destination
        pendingDestination = destination
    }
    
    /// Clear the navigation path
    public func popToRoot() {
        path = NavigationPath()
    }
}

/// Tab identifiers for the main tab view
public enum Tab: String, CaseIterable {
    case dashboard
    case benefit
    case profile
}
