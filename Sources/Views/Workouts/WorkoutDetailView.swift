import SwiftUI
import FitnessTracker

struct WorkoutDetailView: View {
    let workout: Workout
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(workout.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: workout.type.icon)
                            .foregroundColor(.blue)
                        
                        Text(workout.type.rawValue.capitalized)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Date and time
                VStack(alignment: .leading, spacing: 5) {
                    Text("Date & Time")
                        .font(.headline)
                    
                    Text(workout.date, style: .date)
                        .font(.subheadline)
                    
                    Text(workout.date, style: .time)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Stats
                HStack(spacing: 15) {
                    StatCard(
                        title: "Duration",
                        value: formatDuration(workout.duration),
                        icon: "clock",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "Calories",
                        value: "\(Int(workout.caloriesBurned))",
                        icon: "flame.fill",
                        color: .orange
                    )
                }
                .padding(.horizontal)
                
                // Additional info (placeholder)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Notes")
                        .font(.headline)
                    
                    Text("This was a great workout session!")
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutDetailView(
                workout: Workout(
                    id: "1",
                    name: "Morning Run",
                    duration: 1800,
                    caloriesBurned: 350,
                    date: Date(),
                    type: .running
                )
            )
        }
    }
}
