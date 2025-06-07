import Testing
import SwiftUI
@testable import FitJourneyApp

@Suite("AuthStateObserver Tests")
struct AuthStateObserverTests {
    let mockAuthAdapter = MockAuthAdapter()
    
    @Test("Initial state when not authenticated")
    func initialStateWhenNotAuthenticated() {
        // Given
        mockAuthAdapter.isAuthenticated = false
        
        // When
        let observer = AuthStateObserver(authAdapter: mockAuthAdapter)
        
        // Then
        #expect(observer.isNotAuthenticated)
    }
    
    @Test("Initial state when authenticated")
    func initialStateWhenAuthenticated() {
        // Given
        mockAuthAdapter.isAuthenticated = true
        
        // When
        let observer = AuthStateObserver(authAdapter: mockAuthAdapter)
        
        // Then
        #expect(!observer.isNotAuthenticated)
    }
    
    @Test("State updates when authentication changes")
    func stateUpdatesWhenAuthenticationChanges() async throws {
        // Given
        mockAuthAdapter.isAuthenticated = false
        let observer = AuthStateObserver(authAdapter: mockAuthAdapter)
        #expect(observer.isNotAuthenticated)
        
        // When
        mockAuthAdapter.isAuthenticated = true
        
        // Wait for the timer to fire
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
        
        // Then
        #expect(!observer.isNotAuthenticated)
    }
    
    @Test("State updates when logging out")
    func stateUpdatesWhenLoggingOut() async throws {
        // Given
        mockAuthAdapter.isAuthenticated = true
        let observer = AuthStateObserver(authAdapter: mockAuthAdapter)
        #expect(!observer.isNotAuthenticated)
        
        // When
        mockAuthAdapter.isAuthenticated = false
        
        // Wait for the timer to fire
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
        
        // Then
        #expect(observer.isNotAuthenticated)
    }
}

// MARK: - Mock Auth Adapter

class MockAuthAdapter: ApplicationAuthAdapter {
    var isAuthenticated = false
    var currentUser: AppUser?
    
    @MainActor
    func signIn(email: String, password: String) async throws -> AppUser {
        let user = AppUser(id: "1", email: email, name: "Test User")
        self.currentUser = user
        self.isAuthenticated = true
        return user
    }
    
    @MainActor
    func signUp(email: String, password: String, name: String) async throws -> AppUser {
        let user = AppUser(id: "1", email: email, name: name)
        self.currentUser = user
        self.isAuthenticated = true
        return user
    }
    
    func signOut() throws {
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    func getToken() throws -> String {
        return "mock-token"
    }
    
    @MainActor
    func makeAuthView() -> AnyView {
        AnyView(Text("Mock Auth View"))
    }
}
