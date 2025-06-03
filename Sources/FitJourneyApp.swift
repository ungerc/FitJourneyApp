import SwiftUI
import AppCore

@main
struct FitJourneyApp: App {
    // Create the service factory
    private let serviceFactory = ApplicationServiceFactory()

    // Create view models with dependencies
    @State private var authViewModel = AuthViewModel()
    @State private var workoutViewModel = WorkoutViewModel()
    @State private var goalViewModel = GoalViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authViewModel)
                .environment(workoutViewModel)
                .environment(goalViewModel)
                .onAppear {
                    // Initialize view models with services
                    authViewModel.initialize(authManager: serviceFactory.makeAuthAda())
                    workoutViewModel.initialize(workoutService: serviceFactory.makeWorkoutService())
                    goalViewModel.initialize(goalService: serviceFactory.makeGoalService())
                }
        }
    }
}

// Main content view that handles authentication state
struct ContentView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                AuthView()
            }
        }
    }
}

// Main tab view for the authenticated user
struct MainTabView: View {
    @Environment(WorkoutViewModel.self) private var workoutViewModel
    @Environment(GoalViewModel.self) private var goalViewModel
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
            
            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
            
            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .onAppear {
            // Load data when tab view appears
            Task {
                await workoutViewModel.fetchWorkouts()
                await goalViewModel.fetchGoals()
            }
        }
    }
}

// Authentication view for sign in/sign up
struct AuthView: View {
    @State private var showingSignUp = false
    
    var body: some View {
        VStack {
            if showingSignUp {
                SignUpView()
            } else {
                SignInView()
            }
            
            Button(showingSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up") {
                showingSignUp.toggle()
            }
            .padding()
        }
    }
}
