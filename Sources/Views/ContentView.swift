import SwiftUI

// Main content view that handles authentication state
struct ContentView: View {
    private let authAdapter: ApplicationAuthAdapter
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
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
