import SwiftUI

// Since NavigationRouter is already @Observable and passed via .environment(),
// we need to create view modifiers that can access it properly

struct NavigateToWorkoutModifier: ViewModifier {
    let workoutId: String
    @Environment(NavigationRouter.self) private var navigationRouter
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // This won't work as intended - we need a different approach
            }
    }
}

// Better approach: Create methods that take the router as a parameter
extension View {
    /// Creates a navigation action for a workout
    /// Use this with the NavigationRouter from the environment
    func workoutNavigationAction(_ workoutId: String, router: NavigationRouter) {
        router.navigate(to: .workoutDetail(workoutId: workoutId))
    }
    
    /// Creates a navigation action for a goal
    /// Use this with the NavigationRouter from the environment
    func goalNavigationAction(_ goalId: String, router: NavigationRouter) {
        router.navigate(to: .goalDetail(goalId: goalId))
    }
}
