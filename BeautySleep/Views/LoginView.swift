import SwiftUI
struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var redirectToContent = false
    @StateObject var manager = HealthManager()

    
    var body: some View {
        NavigationView {
            var loginTrue = Bool(authViewModel.isLoggedIn)
            VStack(spacing: 20) {
                TextField("Email", text: $authViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $authViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Button("Sign Up") {
                    authViewModel.signUp()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
//                        print("loading")
//                    }
                    print("after sign up:")
                    print(loginTrue)
                }
                .buttonStyle(PrimaryButtonStyle())
                Button("Sign In") {
                    authViewModel.signIn()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
//                        print("loading")
//                    }
                    print("after sign in:")
                    print(loginTrue)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .background(
                NavigationLink(destination: BeautySleepTabView().environmentObject(manager), isActive: $redirectToContent) {
                    EmptyView()
                }

            )
            .onReceive(authViewModel.$isLoggedIn) { newValue in
                if newValue {
                    redirectToContent = true
                    print("redirectToContent is set to true")
                }
            }
        }
        .navigationTitle("Login")
    }
}
struct ContentView: View {
    var body: some View {
        Text("Welcome to the App!")
    }
}
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
