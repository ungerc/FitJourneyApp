import Foundation
import SwiftUI

@Observable
@MainActor
class AuthViewModel {
    private var authManager: ApplicationAuthAdapter?

    var isAuthenticated: Bool = false
    var currentUser: User?
    var errorMessage: String?
    var isLoading: Bool = false
    
    func initialize(authManager: AuthManager) {
        self.authManager = authManager
        self.isAuthenticated = authManager.isAuthenticated
        self.currentUser = authManager.currentUser
    }
    
    func signIn(email: String, password: String) async {
        guard let authManager = authManager else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            currentUser = try await authManager.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = "Failed to sign in: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func signUp(name: String, email: String, password: String) async {
        guard let authManager = authManager else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            currentUser = try await authManager.signUp(email: email, password: password, name: name)
            isAuthenticated = true
        } catch {
            errorMessage = "Failed to sign up: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func signOut() {
        guard let authManager = authManager else { return }
        
        do {
            try authManager.signOut()
            isAuthenticated = false
            currentUser = nil
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
}
