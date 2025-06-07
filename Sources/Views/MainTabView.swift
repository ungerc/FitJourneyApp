import SwiftUI

/// Main tab view for the authenticated user.
/// 
/// Provides three tabs:
/// - Dashboard: Overview of workouts and goals
/// - Benefit: Detailed workout and goal management
/// - Profile: User profile and settings
/// 
/// The selected tab is controlled by the NavigationRouter to support
/// programmatic navigation from anywhere in the app.
internal struct MainTabView: View {
    /// Adapter for goal-related operations
    private let goalAdapter: ApplicationGoalAdapter
    /// Adapter for workout-related operations
    private let workoutAdapter: ApplicationWorkoutAdapter
    /// Router for handling navigation
    @Environment(NavigationRouter.self) private var navigationRouter
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }

    var body: some View {
        @Bindable var router = navigationRouter
        
        TabView(selection: $router.selectedTab) {
            DashboardView(goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
                .tag(Tab.dashboard)

            BenefitView(goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                .tabItem {
                    Label("Benefit", systemImage: "star.fill")
                }
                .tag(Tab.benefit)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(Tab.profile)
        }
    }
}
