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
    @Published var member: Member = .empty
    
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
        return self.member.id
    }
    
    var firstname: String {
        return self.member.firstname
    }
    
    var lastname: String {
        return self.member.lastname
    }
    
    var fullname: String {
        return self.member.firstname + " " + self.member.lastname
    }
    
    var username: String {
        return self.member.firstname
    }

    var email: String {
        return self.member.email
    }
    
    var birthDate: String {
        return self.member.birthDate?.toString(format: "dd/MM/yyyy") ?? ""
    }
    
    var phoneNumber: String {
        return self.member.phone
    }

    var city: String {
        return self.member.city
    }

    var streetAddress: String {
        return self.member.street
    }
    
    var postalCode: Int32 {
        return Int32(self.member.zipcode) ?? 999
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
        let fullname = self.member.firstname + " " + self.member.lastname
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
        
        self.member.id = userId
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                self.member = try JSONDecoder().decode(Member.self, from: data)
                self.member.id = userId
            }
            catch {
                print(error)
            }
        })
    }
}


extension AccountViewModel {
    var isSuperAdministrator: Bool {
        return self.member.isSuperAdministrator
    }
    
    var isAdministrator: Bool {
        return self.member.isAdministrator
    }
    
    var isEducator: Bool {
        return self.member.isEducator
    }
    
    var isMember: Bool {
        return self.member.isMember
    }
}
