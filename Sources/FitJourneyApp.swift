import SwiftUI

@main
struct FitJourneyApp: App {
    // Create the service factory
    private let serviceFactory: ApplicationServiceFactory
    private let authAdapter: ApplicationAuthAdapter

    // Create adapters
    @State private var authStateObserver: AuthStateObserver
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter

    init() {
        serviceFactory = ApplicationServiceFactory()
        authAdapter = serviceFactory.makeAuthAdapter()
        goalAdapter = serviceFactory.makeGoalAdapter()
        workoutAdapter = serviceFactory.makeWorkoutAdapter()
        authStateObserver = AuthStateObserver(authAdapter: authAdapter)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(authAdapter: authAdapter, goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                .environment(authStateObserver)
                .environment(\.authAdapter, authAdapter)
        }
    }
}

// Main content view that handles authentication state
private struct ContentView: View {
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
