import SwiftUI
import AppCore

@main
struct FitJourneyApp: App {
    // Create the service factory
    private let serviceFactory: ApplicationServiceFactory

    // Create view models with dependencies
    @State private var authViewModel: AuthViewModel
    @State private var workoutViewModel: WorkoutViewModel
    @State private var goalViewModel: GoalViewModel

    init() {
        serviceFactory = ApplicationServiceFactory()
        authViewModel = AuthViewModel(authAdapter: serviceFactory.makeAuthAdapter())
        workoutViewModel = WorkoutViewModel(workoutService: serviceFactory.makeWorkoutAdapter())
        goalViewModel = GoalViewModel(goalService: serviceFactory.makeGoalAdapter())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authViewModel)
                .environment(workoutViewModel)
                .environment(goalViewModel)
        }
    }
}

// Main content view that handles authentication state
struct ContentView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        @Bindable var model = authViewModel
        Group {
            MainTabView()
                .fullScreenCover(isPresented: $model.isNotAuthenticated) {
                    AuthView() }
        }
    }
}
