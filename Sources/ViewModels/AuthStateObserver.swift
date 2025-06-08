import SwiftUI
import Combine

/// Observes authentication state changes and provides reactive updates to the UI.
/// Uses Combine to poll the authentication state since the adapter protocol isn't Observable.
@MainActor
@Observable
public class AuthStateObserver {
    /// The authentication adapter being observed
    private let authAdapter: ApplicationAuthAdapter
    
    /// Set of cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    /// Indicates whether the user is NOT authenticated.
    /// This inverse boolean is used for showing/hiding the auth screen.
    public var isNotAuthenticated: Bool = true
    
    /// Creates a new AuthStateObserver.
    /// - Parameter authAdapter: The authentication adapter to observe
    public init(authAdapter: ApplicationAuthAdapter) async {
        self.authAdapter = authAdapter
        self.isNotAuthenticated = await !authAdapter.isAuthenticated
        startObserving()
    }
    
    /// Starts observing authentication state changes.
    /// Uses a timer-based approach to poll the auth state every 0.5 seconds.
    private func startObserving() {
        // Since ApplicationAuthAdapter is a protocol and not Observable,
        // we'll use a timer-based approach but with Combine for better integration
//        Timer.publish(every: 0.5, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                let newValue = !self.authAdapter.isAuthenticated
//                if self.isNotAuthenticated != newValue {
//                    self.isNotAuthenticated = newValue
//                }
//            }
//            .store(in: &cancellables)
    }
}

// Environment key for ApplicationAuthAdapter
private struct AuthAdapterKey: EnvironmentKey {
    static let defaultValue: ApplicationAuthAdapter? = nil
}

internal extension EnvironmentValues {
    var authAdapter: ApplicationAuthAdapter? {
        get { self[AuthAdapterKey.self] }
        set { self[AuthAdapterKey.self] = newValue }
    }
}
