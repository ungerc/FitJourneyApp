import Foundation
import SwiftUI
import AppCore

@Observable
@MainActor
class AuthViewModel {
    private let authAdapter: ApplicationAuthAdapter

    var isNotAuthenticated: Bool = true
    var currentUser: AppUser?
    var errorMessage: String?
    var isLoading: Bool = false

    init(authAdapter: ApplicationAuthAdapter) {
        self.authAdapter = authAdapter
        self.isNotAuthenticated = !authAdapter.isAuthenticated
        self.currentUser = authAdapter.currentUser
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            currentUser = try await authAdapter.signIn(email: email, password: password)
            isNotAuthenticated = false
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
            isNotAuthenticated = false
        } catch {
            errorMessage = "Failed to sign up: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func signOut() {
        do {
            try authAdapter.signOut()
            isNotAuthenticated = true
            currentUser = nil
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
}
