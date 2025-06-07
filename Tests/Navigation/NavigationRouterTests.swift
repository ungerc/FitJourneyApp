import Testing
@testable import FitJourneyApp

@Suite("NavigationRouter Tests")
struct NavigationRouterTests {
    let sut = NavigationRouter()
    
    // MARK: - Navigation Tests
    
    @Test("Navigate to workout detail sets benefit tab")
    func navigateToWorkoutDetail() {
        // Given
        let workoutId = "123"
        
        // When
        sut.navigate(to: .workoutDetail(workoutId: workoutId))
        
        // Then
        #expect(sut.selectedTab == .benefit)
        #expect(sut.pendingDestination == .workoutDetail(workoutId: workoutId))
    }
    
    @Test("Navigate to goal detail sets benefit tab")
    func navigateToGoalDetail() {
        // Given
        let goalId = "456"
        
        // When
        sut.navigate(to: .goalDetail(goalId: goalId))
        
        // Then
        #expect(sut.selectedTab == .benefit)
        #expect(sut.pendingDestination == .goalDetail(goalId: goalId))
    }
    
    @Test("Navigate to goals sets benefit tab")
    func navigateToGoals() {
        // When
        sut.navigate(to: .goals)
        
        // Then
        #expect(sut.selectedTab == .benefit)
        #expect(sut.pendingDestination == .goals)
    }
    
    @Test("Navigate to profile sets profile tab")
    func navigateToProfile() {
        // When
        sut.navigate(to: .profile)
        
        // Then
        #expect(sut.selectedTab == .profile)
        #expect(sut.pendingDestination == .profile)
    }
    
    @Test("Navigate to dashboard sets dashboard tab")
    func navigateToDashboard() {
        // When
        sut.navigate(to: .dashboard)
        
        // Then
        #expect(sut.selectedTab == .dashboard)
        #expect(sut.pendingDestination == .dashboard)
    }
    
    // MARK: - Pop to Root Tests
    
    @Test("Pop to root clears navigation path")
    func popToRootClearsPath() {
        // Given
        sut.path.append(NavigationDestination.goals)
        sut.path.append(NavigationDestination.goalDetail(goalId: "123"))
        
        // When
        sut.popToRoot()
        
        // Then
        #expect(sut.path.isEmpty)
    }
}
