import SwiftUI
import AppCore

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Full Name", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            
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
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .onChange(of: confirmPassword) { _, newValue in
                    passwordsMatch = password == newValue || newValue.isEmpty
                }
            
            if !passwordsMatch {
                Text("Passwords do not match")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                Task {
                    await authViewModel.signUp(name: name, email: email, password: password)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Create Account")
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .disabled(
                name.isEmpty || 
                email.isEmpty || 
                password.isEmpty || 
                confirmPassword.isEmpty || 
                !passwordsMatch ||
                authViewModel.isLoading
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let serviceProvider = ServiceProvider()
        
        SignUpView()
            .environment(AuthViewModel(authAdapter: serviceProvider.authAdapter))
    }
}
