//
//  AccountViewModel.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 02/09/2022.
//

import Foundation
import SwiftUI
import Firebase

class AccountViewModel: ObservableObject {
    @Published var result: Member = .empty
    static let shared = AccountViewModel()
    
    private lazy var databasePath: DatabaseReference? = {
        let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
        let ref = Database.database()
            .reference()
            .child(dbname)
        return ref
    }()
    
    init(){
        self.load()
    }
}


extension AccountViewModel {
    var uid: String {
        return self.result.id
    }
    
    var firstname: String {
        return self.result.firstname
    }
    
    var lastname: String {
        return self.result.lastname
    }
    
    var fullname: String {
        return self.result.firstname + " " + self.result.lastname
    }
    
    var username: String {
        return self.result.firstname
    }

    var email: String {
        return self.result.email
    }
    
    var birthDate: String {
        return self.result.birthDate?.toString(format: "dd/MM/yyyy") ?? ""
    }
    
    var phoneNumber: String {
        return self.result.phone
    }

    var city: String {
        return self.result.city
    }

    var streetAddress: String {
        return self.result.street
    }
    
    var postalCode: Int32 {
        return Int32(self.result.zipcode) ?? 999
    }
    
    var role: String {
        if self.isSuperAdministrator {
            return "Super-Administrateur"
        }
        else if self.isAdministrator {
            return "Administrateur"
        }
        else if self.isEducator {
            return "Éducateur"
        }
        else {
            return "Membre"
        }
    }
    
    var initials: String {
        let fullname = self.result.firstname + " " + self.result.lastname
        return fullname.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + ($1 == "" ? "" : "\($1.first!)") }.uppercased()
    }
    

    
    func load() {
        guard let databasePath = self.databasePath else {
          return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
          return
        }
        
        let dbRef = databasePath.child("users/\(userId)")
        
        self.result.id = userId
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                self.result = try JSONDecoder().decode(Member.self, from: data)
                self.result.id = userId
            }
            catch {
                print(error)
            }
        })
    }
}


extension AccountViewModel {
    var isSuperAdministrator: Bool {
        return self.result.isSuperAdministrator
    }
    
    var isAdministrator: Bool {
        return self.result.isAdministrator
    }
    
    var isEducator: Bool {
        return self.result.isEducator
    }
    
    var isMember: Bool {
        return self.result.isMember
    }
}
