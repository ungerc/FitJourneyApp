import XCTest
@testable import FitJourneyApp
@testable import AppCore

final class AuthStateObserverTests: XCTestCase {
    var authStateObserver: AuthStateObserver!
    var mockAuthAdapter: MockAuthAdapter!
    
    override func setUp() {
        super.setUp()
        mockAuthAdapter = MockAuthAdapter()
        authStateObserver = AuthStateObserver(authAdapter: mockAuthAdapter)
    }
    
    override func tearDown() {
        authStateObserver = nil
        mockAuthAdapter = nil
        super.tearDown()
    }
    
    func testInitialStateWhenNotAuthenticated() {
        // Given
        mockAuthAdapter.isAuthenticated = false
        
        // When
        let observer = AuthStateObserver(authAdapter: mockAuthAdapter)
        
        // Then
        XCTAssertTrue(observer.isNotAuthenticated)
    }
    
    func testInitialStateWhenAuthenticated() {
        // Given
        mockAuthAdapter.isAuthenticated = true
        
        // When
        let observer = AuthStateObserver(authAdapter: mockAuthAdapter)
        
        // Then
        XCTAssertFalse(observer.isNotAuthenticated)
    }
    
    func testStateUpdatesWhenAuthenticationChanges() async throws {
        // Given
        mockAuthAdapter.isAuthenticated = false
        XCTAssertTrue(authStateObserver.isNotAuthenticated)
        
        // When
        mockAuthAdapter.isAuthenticated = true
        
        // Wait for the timer to fire
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
        
        // Then
        XCTAssertFalse(authStateObserver.isNotAuthenticated)
    }
    
    func testStateUpdatesWhenLoggingOut() async throws {
        // Given
        mockAuthAdapter.isAuthenticated = true
        let observer = AuthStateObserver(authAdapter: mockAuthAdapter)
        XCTAssertFalse(observer.isNotAuthenticated)
        
        // When
        mockAuthAdapter.isAuthenticated = false
        
        // Wait for the timer to fire
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
        
        // Then
        XCTAssertTrue(observer.isNotAuthenticated)
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
