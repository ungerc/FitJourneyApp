import SwiftUI

@main
struct FitJourneyApp: App {
    // Create the service factory
    private let serviceFactory: ApplicationServiceFactory
    private let authAdapter: ApplicationAuthAdapter

    // Create adapters
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    
    // Navigation router
    @State private var navigationRouter = NavigationRouter()

    init() {
        serviceFactory = ApplicationServiceFactory()
        authAdapter = serviceFactory.makeAuthAdapter()
        goalAdapter = serviceFactory.makeGoalAdapter()
        workoutAdapter = serviceFactory.makeWorkoutAdapter()
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                authAdapter: authAdapter,
                goalAdapter: goalAdapter,
                workoutAdapter: workoutAdapter,
                navigationRouter: navigationRouter,
                onOpenURL: handleDeepLink
            )
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        // Example: fitjourney://workout/123
        guard let host = url.host else { return }
        
        switch host {
        case "workout":
            if let workoutId = url.pathComponents.dropFirst().first {
                navigationRouter.navigate(to: .workoutDetail(workoutId: workoutId))
            }
        case "goal":
            if let goalId = url.pathComponents.dropFirst().first {
                navigationRouter.navigate(to: .goalDetail(goalId: goalId))
            }
        default:
            break
        }
    }
}

// Helper view to properly initialize AuthStateObserver
private struct RootView: View {
    let authAdapter: ApplicationAuthAdapter
    let goalAdapter: ApplicationGoalAdapter
    let workoutAdapter: ApplicationWorkoutAdapter
    let navigationRouter: NavigationRouter
    let onOpenURL: (URL) -> Void
    
    @State private var authStateObserver: AuthStateObserver
    
    init(authAdapter: ApplicationAuthAdapter,
         goalAdapter: ApplicationGoalAdapter,
         workoutAdapter: ApplicationWorkoutAdapter,
         navigationRouter: NavigationRouter,
         onOpenURL: @escaping (URL) -> Void) {
        self.authAdapter = authAdapter
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
        self.navigationRouter = navigationRouter
        self.onOpenURL = onOpenURL
        self._authStateObserver = AuthStateObserver(authAdapter: authAdapter)
    }
    
    var body: some View {
        ContentView(authAdapter: authAdapter, goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
            .environment(authStateObserver)
            .environment(\.authAdapter, authAdapter)
            .environment(navigationRouter)
            .onOpenURL(perform: onOpenURL)
    }
}

