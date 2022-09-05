//
//  GroupVM.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 05/09/2022.
//

import Foundation
import Firebase
import UIKit

final class GroupVM: ObservableObject, Identifiable, Hashable {
    @Published var group: GroupModel = .empty

    var isValide: Bool {
        !self.group.name.isEmpty
    }
    
    static func == (lhs: GroupVM, rhs: GroupVM) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(group: GroupModel = .empty) {
        self.group = group
    }
    
    func update() {
        let dbEventRef: DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("groupes")
                .child(self.group.id)
            return ref
        }()
        
        var dataDict = self.group.dictionary
        dataDict?["idGroupe"] = self.group.id
        
        do {
          let encoder = JSONEncoder()

          encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

          let data = try encoder.encode(self.group)
          if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
          }
        } catch {
          print(error)
        }
        
        dbEventRef.setValue(dataDict) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                dbEventRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let eventDict = snapshot.value as? [String : Any] {
                        print(eventDict.debugDescription)
                    }
                })
            }
        }
    }
    
    func save() {
        let databasePath: DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("groupes")
            return ref
        }()
        
        var dataDict = self.group.dictionary
        
        //1
        let newEventRef = databasePath.childByAutoId()
        
        let newEventId = newEventRef.key
        
        dataDict?["idGroupe"] = newEventId
        
        print(dataDict as Any)
        
        // 2
        newEventRef.setValue(dataDict) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                newEventRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let eventDict = snapshot.value as? [String : Any] {
                        print(eventDict.debugDescription)
                    }
                })
            }
        }
    }

}

extension GroupVM {
    
    func delete() {
//        print(self.id)
        let dbRefToSelectedItem : DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("groupes")
                .child(self.group.id)
            return ref
        }()
        dbRefToSelectedItem.removeValue()
    }
}

extension GroupVM {
    var administrator: String {
        let result = self.group.members.values.first { $0.role == EventMember.Role.administrator }
        
        guard let firstname = result?.firstname else {
            return ""
        }
        
        guard let lastname = result?.lastname else {
            return ""
        }
        
        return firstname + " " + lastname
    }
    
    
    var isAdministrator: Bool {
        guard let userId = Auth.auth().currentUser?.uid else {
          return false
        }
        
        if let currentUser = self.group.members[userId] {
            return currentUser.role == EventMember.Role.administrator
        }
        
        return false
    }
}


