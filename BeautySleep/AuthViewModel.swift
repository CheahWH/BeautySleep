import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            // Success - Navigate to main app screen or perform other actions
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            // Success - Navigate to main app screen or perform other actions
        }
    }
}
