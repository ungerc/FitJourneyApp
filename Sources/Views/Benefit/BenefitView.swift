import SwiftUI

/// Combined view for workouts and goals with navigation interface.
/// Provides a unified experience for tracking fitness benefits.
internal struct BenefitView: View {
    private let goalAdapter: ApplicationGoalAdapter
    private let workoutAdapter: ApplicationWorkoutAdapter
    @Environment(NavigationRouter.self) private var navigationRouter
    @State private var showingAddGoal = false
    
    init(goalAdapter: ApplicationGoalAdapter, workoutAdapter: ApplicationWorkoutAdapter) {
        self.goalAdapter = goalAdapter
        self.workoutAdapter = workoutAdapter
    }
    
    var body: some View {
        @Bindable var router = navigationRouter
        
        NavigationStack(path: $router.path) {
            List {
                Section {
                    NavigationLink(destination: workoutAdapter.makeWorkoutsView()) {
                        HStack {
                            Image(systemName: "figure.run")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Workouts")
                                    .font(.headline)
                                Text("Track your exercise sessions")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: goalAdapter.makeGoalsView()) {
                        HStack {
                            Image(systemName: "target")
                                .font(.title2)
                                .foregroundColor(.green)
                                .frame(width: 40, height: 40)
                                .background(Color.green.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Goals")
                                    .font(.headline)
                                Text("Set and track your fitness goals")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Quick Stats")) {
                    QuickStatsView(goalAdapter: goalAdapter, workoutAdapter: workoutAdapter)
                }
            }
            .navigationTitle("Benefit")
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .workoutDetail(let workoutId):
                    workoutAdapter.makeWorkoutDetailView(for: workoutId)
                case .goalDetail(let goalId):
                    goalAdapter.makeGoalDetailView(for: goalId)
                case .goals:
                    goalAdapter.makeGoalsView()
                default:
                    EmptyView()
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                goalAdapter.makeAddGoalView()
            }
        }
        .onAppear {
            handlePendingNavigation()
        }
    }
    
    private func handlePendingNavigation() {
        if let destination = navigationRouter.pendingDestination {
            navigationRouter.path.append(destination)
            navigationRouter.pendingDestination = nil
        }
    }
}


