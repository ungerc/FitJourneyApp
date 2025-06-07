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
    
    // Navigation router
    @State private var navigationRouter = NavigationRouter()

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
                .environment(navigationRouter)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
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

