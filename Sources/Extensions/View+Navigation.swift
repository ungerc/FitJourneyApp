import SwiftUI

// Since NavigationRouter is already @Observable and passed via .environment(),
// we need to create view modifiers that can access it properly

/// A view modifier that attempts to navigate to a workout detail on appear.
/// Note: This approach has limitations as onAppear may not have the right timing.
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
    /// Creates a navigation action for a workout.
    /// 
    /// - Parameters:
    ///   - workoutId: The ID of the workout to navigate to
    ///   - router: The NavigationRouter instance from the environment
    /// 
    /// Example usage:
    /// ```swift
    /// Button("View Workout") {
    ///     workoutNavigationAction("123", router: navigationRouter)
    /// }
    /// ```
    func workoutNavigationAction(_ workoutId: String, router: NavigationRouter) {
        router.navigate(to: .workoutDetail(workoutId: workoutId))
    }
    
    /// Creates a navigation action for a goal.
    /// 
    /// - Parameters:
    ///   - goalId: The ID of the goal to navigate to
    ///   - router: The NavigationRouter instance from the environment
    /// 
    /// Example usage:
    /// ```swift
    /// Button("View Goal") {
    ///     goalNavigationAction("456", router: navigationRouter)
    /// }
    /// ```
    func goalNavigationAction(_ goalId: String, router: NavigationRouter) {
        router.navigate(to: .goalDetail(goalId: goalId))
    }
}
