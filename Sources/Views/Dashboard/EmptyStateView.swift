import SwiftUI

/// A view displayed when there's no data to show.
/// Provides a consistent empty state UI across the app.
struct EmptyStateView: View {
    /// The message to display to the user
    let message: String
    /// SF Symbol name for the icon
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
