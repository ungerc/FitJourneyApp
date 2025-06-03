import Foundation
import SwiftUI
import AppCore

@Observable
@MainActor
class GoalViewModel {
    private let goalService: ApplicationGoalAdapter

    var goals: [AppGoal] = []
    var isLoading: Bool = false
    var errorMessage: String?

    init(goalService: ApplicationGoalAdapter) {
        self.goalService = goalService
    }

    func fetchGoals() async {
        isLoading = true
        errorMessage = nil

        do {
            goals = try await goalService.fetchGoals()
        } catch {
            errorMessage = "Failed to fetch goals: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func addGoal(name: String, type: AppGoalType, targetValue: Double, currentValue: Double, unit: String, deadline: Date?) async {
        isLoading = true
        errorMessage = nil

        //        let goal = AppGoal(
        //            id: UUID().uuidString,
        //            name: name,
        //            targetValue: targetValue,
        //            currentValue: currentValue,
        //            unit: unit,
        //            deadline: deadline,
        //            type: type
        //        )

        do {
            let newGoal = try await goalService.addGoal(
                name: name,
                type: type,
                targetValue: targetValue,
                currentValue: currentValue,
                unit: unit,
                deadline: deadline
            )
            goals.append(newGoal)
        } catch {
            errorMessage = "Failed to add goal: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func updateGoalProgress(id: String, newValue: Double) async {
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
    var completedGoals: [AppGoal] {
        goals.filter { $0.progress >= 1.0 }
    }

    var inProgressGoals: [AppGoal] {
        goals.filter { $0.progress < 1.0 }
    }
}
