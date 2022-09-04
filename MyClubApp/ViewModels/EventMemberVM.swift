//
//  EventMemberVM.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import Foundation


import Foundation
import Firebase

final class EventMemberVM: ObservableObject {
    @Published var member: EventMember = .empty
    
    private lazy var databasePath: DatabaseReference? = {
        let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
        let ref = Database.database()
            .reference()
            .child(dbname)
            .child("groupes")
        return ref
    }()
    
    var isValid: Bool {
        !self.member.firstname.isEmpty ||
        !self.member.lastname.isEmpty
    }
}

extension EventMemberVM {
    func save() {
        guard let databasePath = self.databasePath else {
          return
        }
        
        guard let usurId = Auth.auth().currentUser?.uid else {
          return
        }
        
        var dataDict = self.member.dictionary
        
        dataDict?["id_administrateur"] = usurId
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
    
    
    func append(nodeid: String) {
        let dbMember: DatabaseReference? = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("\(dbname)/\(nodeid)/lesMembres")
            return ref
        }()
        
        guard let databasePath = dbMember else {
          return
        }
        
        var dataDict = self.member.dictionary
        
        let newEventMemberRef = databasePath.childByAutoId()
        let newEventMemberId = newEventMemberRef.key
        dataDict?["id"] = newEventMemberId
        
        newEventMemberRef.setValue(dataDict) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                newEventMemberRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let eventDict = snapshot.value as? [String : Any] {
                        print(eventDict.debugDescription)
                    }
                })
            }
        }
    }
}
