import SwiftUI

/// A compact view for displaying a single statistic with an icon.
/// Used in the QuickStatsView to show workout and goal summaries.
struct StatItem: View {
    /// The title/label for the statistic
    let title: String
    /// The numeric value to display
    let value: String
    /// SF Symbol name for the icon
    let icon: String
    /// Color theme for the icon
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
