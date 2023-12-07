import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        NavigationView {
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
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Sign In") {
                    authViewModel.signIn()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        }
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

