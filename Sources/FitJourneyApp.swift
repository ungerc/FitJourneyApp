import SwiftUI
import AppCore

@main
struct FitJourneyApp: App {
    // Create the service factory
    private let serviceFactory: ApplicationServiceFactory
    private let authAdapter: ApplicationAuthAdapter

    // Create view models with dependencies
    @State private var workoutViewModel: WorkoutViewModel
    @State private var goalViewModel: GoalViewModel
    @State private var authStateObserver: AuthStateObserver

    init() {
        serviceFactory = ApplicationServiceFactory()
        authAdapter = serviceFactory.makeAuthAdapter()
        workoutViewModel = WorkoutViewModel(workoutService: serviceFactory.makeWorkoutAdapter())
        goalViewModel = GoalViewModel(goalService: serviceFactory.makeGoalAdapter())
        authStateObserver = AuthStateObserver(authAdapter: authAdapter)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(authAdapter: authAdapter)
                .environment(workoutViewModel)
                .environment(goalViewModel)
                .environment(authStateObserver)
                .environment(\.authAdapter, authAdapter)
        }
    }
}

// Main content view that handles authentication state
private struct ContentView: View {
    private let authAdapter: ApplicationAuthAdapter
    @Environment(AuthStateObserver.self) private var authStateObserver
    
    init(authAdapter: ApplicationAuthAdapter) {
        self.authAdapter = authAdapter
    }

    var body: some View {
        @Bindable var authState = authStateObserver
        
        Group {
            MainTabView()
                .fullScreenCover(isPresented: $authState.isNotAuthenticated) {
                    authAdapter.makeAuthView()
                        .interactiveDismissDisabled(true)
                }
        }
    }
}
