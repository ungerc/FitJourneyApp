import SwiftUI
import AppCore

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
            Button(action: {
                Task {
                    await authViewModel.signIn(email: email, password: password)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
            
            Button("Forgot Password?") {
                // Handle forgot password
            }
            .foregroundColor(.blue)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let serviceProvider = ServiceProvider()
        
        SignInView()
            .environment(AuthViewModel(authAdapter: serviceProvider.authAdapter))
    }
}
