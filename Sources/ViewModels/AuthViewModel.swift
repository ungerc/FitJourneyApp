import Foundation
import SwiftUI
import AppCore

@Observable
@MainActor
class AuthViewModel {
    private let authAdapter: ApplicationAuthAdapter

    var isAuthenticated: Bool = false
    var currentUser: AppUser?
    var errorMessage: String?
    var isLoading: Bool = false

    init(authAdapter: ApplicationAuthAdapter) {
        self.authAdapter = authAdapter
        self.isAuthenticated = authAdapter.isAuthenticated
        self.currentUser = authAdapter.currentUser
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            currentUser = try await authAdapter.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = "Failed to sign in: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func signUp(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            currentUser = try await authAdapter.signUp(email: email, password: password, name: name)
            isAuthenticated = true
        } catch {
            errorMessage = "Failed to sign up: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func signOut() {
        do {
            try authAdapter.signOut()
            isAuthenticated = false
            currentUser = nil
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
}
