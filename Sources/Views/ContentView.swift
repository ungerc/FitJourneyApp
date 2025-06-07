import SwiftUI

/// Main content view that handles authentication state.
/// 
/// This view:
/// - Shows the main tab view when authenticated
/// - Presents the authentication view as a full screen cover when not authenticated
/// - Prevents dismissal of the auth view to ensure users must authenticate
struct ContentView: View {
    /// Adapter for authentication operations
    private let authAdapter: ApplicationAuthAdapter
    /// Adapter for goal-related operations
    private let goalAdapter: ApplicationGoalAdapter
    /// Adapter for workout-related operations
    private let workoutAdapter: ApplicationWorkoutAdapter
    /// Observer for authentication state changes
    @Environment(AuthStateObserver.self) private var authStateObserver
    
    init(authAdapter: ApplicationAuthAdapter, goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.authAdapter = authAdapter
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }

    var body: some View {
        @Bindable var authState = authStateObserver
        
        Group {
            MainTabView(goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                .fullScreenCover(isPresented: $authState.isNotAuthenticated) {
                    authAdapter.makeAuthView()
                        .interactiveDismissDisabled(true)
                }
        }
    }
}
