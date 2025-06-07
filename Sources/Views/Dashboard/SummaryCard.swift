import SwiftUI

/// A reusable card component for displaying summary statistics.
/// Used in the dashboard to show key metrics like calories burned, active goals, etc.
struct SummaryCard: View {
    /// The title of the metric being displayed
    let title: String
    /// The value to display prominently
    let value: String
    /// SF Symbol name for the icon
    let icon: String
    /// Color theme for the icon
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}
