//
//  AuthenticationService.swift
//  MyClubApp
//
//  Created by Pole Star on 03/09/2022.
//

import Foundation
import Firebase

class AuthenticationService: ObservableObject {
    
    static func signUp (email:String, password:String, handle:@escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handle)
    }
    
    static func signIn (email:String, password:String, handle:@escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handle)
    }
    
    static func reset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    static func signOut() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            }
            catch {
              print (error)
            }
        }
    }
}
