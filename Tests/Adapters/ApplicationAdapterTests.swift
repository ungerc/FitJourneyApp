import Testing
import Foundation
@testable import FitJourneyApp
@testable import Authentication
@testable import FitnessTracker

@Suite("Application Adapter Protocol Tests")
struct ApplicationAdapterProtocolTests {
    
    // MARK: - Model Conversion Tests
    
    @Test("AppUser converts from AuthUser correctly")
    func appUserConversion() {
        // Given
        let authUser = AuthUser(id: "123", email: "test@example.com", name: "Test User")
        
        // When
        let appUser = AppUser(authUser: authUser)
        
        // Then
        #expect(appUser.id == authUser.id)
        #expect(appUser.email == authUser.email)
        #expect(appUser.name == authUser.name)
    }
    
    @Test("AppWorkout converts from Workout correctly")
    func appWorkoutConversion() {
        // Given
        let workout = Workout(
            id: "123",
            name: "Morning Run",
            duration: 1800,
            caloriesBurned: 250,
            date: Date(),
            type: .running
        )
        
        // When
        let appWorkout = AppWorkout(workout: workout)
        
        // Then
        #expect(appWorkout.id == workout.id)
        #expect(appWorkout.name == workout.name)
        #expect(appWorkout.duration == workout.duration)
        #expect(appWorkout.caloriesBurned == workout.caloriesBurned)
        #expect(appWorkout.date == workout.date)
        #expect(appWorkout.type == .running)
    }
    
    @Test("AppGoal converts from Goal correctly")
    func appGoalConversion() {
        // Given
        let goal = Goal(
            id: "123",
            name: "Weight Loss",
            targetValue: 10,
            currentValue: 3,
            unit: "kg",
            deadline: Date(),
            type: .weight
        )
        
        // When
        let appGoal = AppGoal(goal: goal)
        
        // Then
        #expect(appGoal.id == goal.id)
        #expect(appGoal.name == goal.name)
        #expect(appGoal.targetValue == goal.targetValue)
        #expect(appGoal.currentValue == goal.currentValue)
        #expect(appGoal.unit == goal.unit)
        #expect(appGoal.deadline == goal.deadline)
        #expect(appGoal.type == .weight)
        #expect(appGoal.progress == 0.3)
    }
    
    @Test("WorkoutType conversion works both ways")
    func workoutTypeConversion() {
        // Test all workout types
        let workoutTypes: [(FitnessTracker.WorkoutType, AppWorkoutType)] = [
            (.running, .running),
            (.cycling, .cycling),
            (.swimming, .swimming),
            (.weightLifting, .weightLifting),
            (.yoga, .yoga),
            (.hiit, .hiit)
        ]
        
        for (fitnessType, expectedAppType) in workoutTypes {
            let appType = AppWorkoutType(fitnessType: fitnessType)
            #expect(appType == expectedAppType)
        }
    }
    
    @Test("GoalType conversion works both ways")
    func goalTypeConversion() {
        // Test all goal types
        let goalTypes: [(FitnessTracker.GoalType, AppGoalType)] = [
            (.weight, .weight),
            (.steps, .steps),
            (.workouts, .workouts),
            (.distance, .distance),
            (.calories, .calories)
        ]
        
        for (fitnessType, expectedAppType) in goalTypes {
            let appType = AppGoalType(fitnessType: fitnessType)
            #expect(appType == expectedAppType)
        }
    }
    
    @Test("WorkoutType icons are defined")
    func workoutTypeIcons() {
        for type in AppWorkoutType.allCases {
            #expect(!type.icon.isEmpty)
        }
    }
    
    @Test("GoalType icons are defined")
    func goalTypeIcons() {
        for type in AppGoalType.allCases {
            #expect(!type.icon.isEmpty)
        }
    }
}
