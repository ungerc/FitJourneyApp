import SwiftUI

// Main tab view for the authenticated user
internal struct MainTabView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
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
