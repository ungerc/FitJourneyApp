# FitJourneyApp Dependency Graph

This document visualizes the dependency relationships in the FitJourneyApp architecture.

## High-Level Architecture

```mermaid
graph TB
    subgraph "FitJourneyApp (Main App)"
        App[FitJourneyApp.swift]
        ContentView[ContentView]
        MainTabView[MainTabView]
        ServiceFactory[ApplicationServiceFactory]
        ServiceProvider[ServiceProvider]
    end

    subgraph "Views Layer"
        DashboardView[DashboardView]
        BenefitView[BenefitView]
        ProfileView[ProfileView]
        
        subgraph "Dashboard Components"
            WorkoutCard[WorkoutCard]
            GoalProgressCard[GoalProgressCard]
            SummaryCard[SummaryCard]
            EmptyStateView[EmptyStateView]
            CompletedGoalsView[CompletedGoalsView]
        end
        
        subgraph "Benefit Components"
            QuickStatsView[QuickStatsView]
            StatItem[StatItem]
        end
    end

    subgraph "Navigation"
        NavigationRouter[NavigationRouter]
        ViewExtensions[View+Navigation]
    end

    subgraph "View Models"
        AuthStateObserver[AuthStateObserver]
    end

    subgraph "Adapters Layer"
        AppAdapters[ApplicationAdapters]
        ConcreteAdapters[ConcreteAdapters]
        WorkoutDetailLoader[WorkoutDetailLoader]
        GoalDetailLoader[GoalDetailLoader]
    end

    subgraph "External Modules"
        subgraph "Authentication Module"
            AuthManager[AuthManager]
            AuthViewModel[AuthViewModel]
            AuthView[AuthView]
            SignInView[SignInView]
            SignUpView[SignUpView]
        end
        
        subgraph "FitnessTracker Module"
            WorkoutViewModel[WorkoutViewModel]
            GoalViewModel[GoalViewModel]
            WorkoutsView[WorkoutsView]
            GoalsView[GoalsView]
            WorkoutDetailView[WorkoutDetailView]
            GoalDetailView[GoalDetailView]
            AddWorkoutView[AddWorkoutView]
            AddGoalView[AddGoalView]
        end
        
        subgraph "Networking Module"
            NetworkManager[NetworkManager]
        end
    end

    %% Main App Dependencies
    App --> ServiceFactory
    App --> AuthStateObserver
    App --> NavigationRouter
    App --> ContentView
    
    ServiceFactory --> ServiceProvider
    ServiceProvider --> ConcreteAdapters
    
    ContentView --> MainTabView
    ContentView --> AuthStateObserver
    
    MainTabView --> DashboardView
    MainTabView --> BenefitView
    MainTabView --> ProfileView
    MainTabView --> NavigationRouter
    
    %% Dashboard Dependencies
    DashboardView --> WorkoutCard
    DashboardView --> GoalProgressCard
    DashboardView --> SummaryCard
    DashboardView --> EmptyStateView
    DashboardView --> CompletedGoalsView
    DashboardView --> NavigationRouter
    
    %% Benefit Dependencies
    BenefitView --> QuickStatsView
    BenefitView --> NavigationRouter
    QuickStatsView --> StatItem
    
    %% Adapter Dependencies
    ConcreteAdapters --> AuthManager
    ConcreteAdapters --> WorkoutViewModel
    ConcreteAdapters --> GoalViewModel
    ConcreteAdapters --> NetworkManager
    
    %% Loader Dependencies
    WorkoutDetailLoader --> WorkoutDetailView
    GoalDetailLoader --> GoalDetailView
    
    %% Auth Dependencies
    AuthView --> SignInView
    AuthView --> SignUpView
    AuthView --> AuthViewModel
    AuthViewModel --> AuthManager
    
    %% FitnessTracker Dependencies
    WorkoutsView --> WorkoutViewModel
    WorkoutsView --> AddWorkoutView
    GoalsView --> GoalViewModel
    GoalsView --> AddGoalView
    GoalDetailView --> GoalViewModel
    
    %% State Observer
    AuthStateObserver --> AppAdapters

    style App fill:#f9f,stroke:#333,stroke-width:4px
    style ServiceFactory fill:#bbf,stroke:#333,stroke-width:2px
    style NavigationRouter fill:#bfb,stroke:#333,stroke-width:2px
    style ConcreteAdapters fill:#fbf,stroke:#333,stroke-width:2px
```

## Data Flow

```mermaid
graph LR
    subgraph "User Interaction"
        User[User]
    end
    
    subgraph "UI Layer"
        Views[SwiftUI Views]
        ViewModels[View Models]
    end
    
    subgraph "Application Layer"
        Adapters[Adapters]
        Models[App Models]
    end
    
    subgraph "Domain Layer"
        Services[Services]
        DomainModels[Domain Models]
    end
    
    subgraph "Infrastructure"
        Network[Network Layer]
        Storage[Local Storage]
    end
    
    User --> Views
    Views --> ViewModels
    ViewModels --> Adapters
    Adapters --> Models
    Adapters --> Services
    Services --> DomainModels
    Services --> Network
    Services --> Storage
    
    style User fill:#f96,stroke:#333,stroke-width:2px
    style Views fill:#9f9,stroke:#333,stroke-width:2px
    style Adapters fill:#99f,stroke:#333,stroke-width:2px
    style Services fill:#f99,stroke:#333,stroke-width:2px
```

## Module Dependencies

```mermaid
graph TD
    subgraph "FitJourneyApp"
        MainApp[Main App]
    end
    
    subgraph "Feature Modules"
        Auth[Authentication]
        Fitness[FitnessTracker]
    end
    
    subgraph "Core Modules"
        Network[Networking]
    end
    
    MainApp --> Auth
    MainApp --> Fitness
    MainApp --> Network
    
    Auth --> Network
    Fitness --> Network
    Fitness --> Auth
    
    style MainApp fill:#f9f,stroke:#333,stroke-width:4px
    style Auth fill:#9ff,stroke:#333,stroke-width:2px
    style Fitness fill:#ff9,stroke:#333,stroke-width:2px
    style Network fill:#9f9,stroke:#333,stroke-width:2px
```

## Key Architectural Patterns

1. **Adapter Pattern**: The app uses adapters to bridge between domain modules and the UI layer
2. **Factory Pattern**: `ServiceFactory` and `ServiceProvider` create and manage service instances
3. **Observer Pattern**: `AuthStateObserver` monitors authentication state changes
4. **Router Pattern**: `NavigationRouter` handles app-wide navigation
5. **MVVM Pattern**: Views are backed by ViewModels that manage state and business logic

## Dependency Injection Flow

```mermaid
graph TD
    App[FitJourneyApp] --> Factory[ApplicationServiceFactory]
    Factory --> Provider[ServiceProvider]
    Provider --> Network[NetworkManager]
    Provider --> Auth[AuthManager]
    Provider --> Workout[WorkoutService]
    Provider --> Goal[GoalService]
    
    Network --> AuthAdapter[ConcreteAuthAdapter]
    Auth --> AuthAdapter
    
    Network --> WorkoutAdapter[ConcreteWorkoutAdapter]
    Workout --> WorkoutAdapter
    Auth --> WorkoutAdapter
    
    Network --> GoalAdapter[ConcreteGoalAdapter]
    Goal --> GoalAdapter
    Auth --> GoalAdapter
    
    AuthAdapter --> ContentView
    WorkoutAdapter --> Views[Various Views]
    GoalAdapter --> Views
    
    style App fill:#f9f,stroke:#333,stroke-width:4px
    style Factory fill:#bbf,stroke:#333,stroke-width:2px
    style Provider fill:#bfb,stroke:#333,stroke-width:2px
```
