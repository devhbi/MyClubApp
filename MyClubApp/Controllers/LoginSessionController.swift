//
//  LoginSessionController.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 02/09/2022.
//

import SwiftUI
import Firebase
import Combine


class LoginSessionController: ObservableObject {
    enum AuthenticationState {
        case login
        case signup
        case failed
        case processing
        case none
    }
    
    var didChange = PassthroughSubject<LoginSessionController, Never>()
    @Published var session: User? {didSet{self.didChange.send(self)}}
    @Published var currentLoginState: AuthenticationState = .none
    @State var signInErrorMessage = ""

    var handle: AuthStateDidChangeListenerHandle?
    
    func loginListen() {
        handle = Auth.auth().addStateDidChangeListener({(auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, displayName: user.displayName, email: user.email)
            }
            else{
                self.session = nil
            }
        })
    }
    
    func signUpUser(userEmail: String, userPassword: String) {
        self.currentLoginState = .processing
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.currentLoginState = .failed
                    self.signInErrorMessage = error!.localizedDescription
                    return
                }
                switch authResult {
                case .none:
                    self.currentLoginState = .failed
                case .some(_):
                    withAnimation {
                        self.currentLoginState = .signup
                    }
                }
            }
        }
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        self.currentLoginState = .processing
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.currentLoginState = .failed
                    self.signInErrorMessage = error!.localizedDescription
                    return
                }
                switch authResult {
                case .none:
                    self.currentLoginState = .failed
                case .some(_):
                    withAnimation {
                        self.currentLoginState = .login
                    }
                }
            }
        }
    }
    
    func resetUser(withEmail email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.currentLoginState = .failed
                    self.signInErrorMessage = error!.localizedDescription
                    return
                }
            }
        }
    }
    
    func signUp (email:String, password:String, handle:@escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handle)
    }
    
    func signIn (email:String, password:String, handle:@escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handle)
    }
    
    func reset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    func signOutUser () {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.session = nil
        }
        catch let signOutError as NSError {
            self.signInErrorMessage = signOutError.localizedDescription
            self.currentLoginState = .failed
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}

class User {
    var uid: String
    var email: String?
    var displayName: String?

    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }

}

class FirebaseManager: NSObject {

    let auth: Auth

    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()

        self.auth = Auth.auth()

        super.init()
    }

}
