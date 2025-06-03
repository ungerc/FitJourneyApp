import SwiftUI
import AppCore

struct AuthView: View {
    @State private var isSignIn = true
    @State private var showConfetti = false
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo and app name
                VStack {
                    Image(systemName: "figure.run")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("FitJourney")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                }
                .padding(.top, 50)
                
                // Toggle between sign in and sign up
                Picker("", selection: $isSignIn) {
                    Text("Sign In").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                if isSignIn {
                    SignInView()
                } else {
                    SignUpView()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .alert(item: Binding<AuthAlert?>(
                get: { authViewModel.errorMessage != nil ? AuthAlert(message: authViewModel.errorMessage!) : nil },
                set: { _ in authViewModel.errorMessage = nil }
            )) { alert in
                Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
            }
            .onChange(of: authViewModel.isNotAuthenticated) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    // User just logged in successfully
                    showConfetti = true
                    
                    // Hide confetti after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showConfetti = false
                    }
                }
            }
            .overlay {
                ConfettiView(isShowing: $showConfetti)
            }
        }
    }
}

struct AuthAlert: Identifiable {
    var id: String { message }
    let message: String
}

//#Preview {
//    let serviceProvider = ServiceProvider()
//    
//    return AuthView()
//        .environment(AuthViewModel(authAdapter: serviceProvider.authAdapter))
//}
