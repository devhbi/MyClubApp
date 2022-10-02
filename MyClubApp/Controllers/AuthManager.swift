//
//  AuthManager.swift
//  MyClubApp
//
//  Created by polestar on 01/10/2022.
//

import Foundation
import SwiftUI

import GoogleSignIn
import Firebase
import Combine

import AuthenticationServices
import CryptoKit


enum LoginOption {
    case signInWithApple
    case signInWitGoogle
    case emailAndPassword(email: String, password: String)
}

class AuthManager: NSObject, ObservableObject {

    var didChange = PassthroughSubject<AuthManager, Never>()
    @Published var loggedInUser: User? {didSet{self.didChange.send(self)}}
    @Published var isAuthenticating = false
    @Published var error: NSError?

    static let shared = AuthManager()

    private let auth = Auth.auth()
    fileprivate var currentNonce: String?
    private var nonceGenerator = NonceGenerator()
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = auth.addStateDidChangeListener({(auth, user) in
            if let user = user {
                self.loggedInUser = User(uid: user.uid, displayName: user.displayName, email: user.email)
            }
            else{
                self.loggedInUser = nil
            }
        })
    }
    
    func login(with loginOption: LoginOption) {
        self.isAuthenticating = true
        self.error = nil

        switch loginOption {
            case .signInWithApple:
                handleSignInWithApple()

            case let .emailAndPassword(email, password):
                handleSignInWith(email: email, password: password)
            
            case .signInWitGoogle:
                handleSignInWithGoogle()
        }
    }
    
    private func handleAuthResultCompletion(auth: AuthDataResult?, error: Error?) {
        DispatchQueue.main.async {
            self.isAuthenticating = false
            let user = Auth.auth().currentUser
            if let user = user {
                self.loggedInUser = User(uid: user.uid, displayName: user.displayName, email: user.email)
            }
            else if let error = error {
                self.error = error as NSError
            }
        }
    }

    func signup(email: String, password: String, passwordConfirmation: String) {
        guard password == passwordConfirmation else {
            self.error = NSError(domain: "", code: 9210, userInfo: [NSLocalizedDescriptionKey: "Password and confirmation does not match"])
            return
        }

        self.isAuthenticating = true
        self.error = nil

        auth.createUser(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }
    
    func resetUser(withEmail email: String){
        auth.sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.error = error as? NSError
                    return
                }
            }
        }
    }

    private func handleSignInWith(email: String, password: String) {
        auth.signIn(withEmail: email, password: password, completion: handleAuthResultCompletion)
    }

    func signout() {
        GIDSignIn.sharedInstance.signOut()
        try? auth.signOut()
    }
}

extension AuthManager {
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            print(error.localizedDescription)
            return
        }

        // 2
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

        // 3
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func handleSignInWithGoogle() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
        else {
            // 2
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            // 3
            let configuration = GIDConfiguration(clientID: clientID)

            // 4
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

            // 5
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) {
                [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
}

extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // 1
    private func handleSignInWithApple() {
        currentNonce = nonceGenerator.nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonceGenerator.sha256

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    // 2
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows[0]
    }

    // 3
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential, completion: handleAuthResultCompletion)
        }
    }

    // 4
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error)")
        self.isAuthenticating = false
        self.error = error as NSError
    }

}
