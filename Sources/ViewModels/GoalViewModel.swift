import Foundation
import SwiftUI

@Observable
@MainActor
class GoalViewModel {
    private var goalService: GoalServiceProtocol?

    var goals: [Goal] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    func initialize(goalService: GoalService) {
        self.goalService = goalService
    }
    
    func fetchGoals() async {
        guard let goalService = goalService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            goals = try await goalService.fetchGoals()
        } catch {
            errorMessage = "Failed to fetch goals: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addGoal(name: String, type: GoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async {
        guard let goalService = goalService else { return }
        
        isLoading = true
        errorMessage = nil
        
        let goal = Goal(
            id: UUID().uuidString,
            name: name,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadline: deadline,
            type: type
        )
        
        do {
            let newGoal = try await goalService.addGoal(goal)
            goals.append(newGoal)
        } catch {
            errorMessage = "Failed to add goal: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func updateGoalProgress(id: String, newValue: Double) async {
        guard let goalService = goalService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedGoal = try await goalService.updateGoalProgress(id: id, newValue: newValue)
            if let index = goals.firstIndex(where: { $0.id == id }) {
                goals[index] = updatedGoal
            }
        } catch {
            errorMessage = "Failed to update goal progress: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func deleteGoal(id: String) async {
        guard let goalService = goalService else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await goalService.deleteGoal(id: id)
            goals.removeAll { $0.id == id }
        } catch {
            errorMessage = "Failed to delete goal: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // Helper computed properties
    var completedGoals: [Goal] {
        goals.filter { $0.progress >= 1.0 }
    }
    
    var inProgressGoals: [Goal] {
        goals.filter { $0.progress < 1.0 }
    }
}
