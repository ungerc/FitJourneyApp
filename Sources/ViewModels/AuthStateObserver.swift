import SwiftUI
import AppCore
import Combine

@Observable
public class AuthStateObserver {
    private let authAdapter: ApplicationAuthAdapter
    private var cancellables = Set<AnyCancellable>()
    
    public private(set) var isNotAuthenticated: Bool = true
    
    public init(authAdapter: ApplicationAuthAdapter) {
        self.authAdapter = authAdapter
        self.isNotAuthenticated = !authAdapter.isAuthenticated
        startObserving()
    }
    
    private func startObserving() {
        // Since ApplicationAuthAdapter is a protocol and not Observable,
        // we'll use a timer-based approach but with Combine for better integration
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let newValue = !self.authAdapter.isAuthenticated
                if self.isNotAuthenticated != newValue {
                    self.isNotAuthenticated = newValue
                }
            }
            .store(in: &cancellables)
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
