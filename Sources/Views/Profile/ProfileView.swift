import SwiftUI
import AppCore

internal struct ProfileView: View {
    @Environment(\.authAdapter) private var authAdapter: ApplicationAuthAdapter?

    var body: some View {
        NavigationView {
            List {
                if let user = authAdapter?.currentUser {
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Personal Information")) {
                        Label("Personal Information", systemImage: "person")
                    }
                    
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy", systemImage: "lock")
                    }
                }
                
                Section(header: Text("App")) {
                    NavigationLink(destination: Text("About")) {
                        Label("About", systemImage: "info.circle")
                    }
                    
                    NavigationLink(destination: Text("Help & Support")) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                }
                
                Section {
                    Button(action: {
                        do {
                            try authAdapter?.signOut()
                        } catch {
                            print("Failed to sign out: \(error)")
                        }
                    }) {
                        HStack {
                            Text("Sign Out")
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right.square")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let networkManager = NetworkManager()
//        let authManager = AuthManager(networkManager: networkManager)
//        
//        ProfileView()
//            .environmentObject(AuthViewModel(authManager: authManager))
//    }
//}
