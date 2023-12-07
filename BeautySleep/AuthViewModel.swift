import SwiftUI
import FirebaseAuth
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                // Authentication succeeded
                print("success")
                self?.isLoggedIn = true
                print(self?.isLoggedIn)
            }
        }
    }
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                // Authentication succeeded
                print("success sign in")
                self?.isLoggedIn = true
                print(self?.isLoggedIn)
            }
        }
    }
}
