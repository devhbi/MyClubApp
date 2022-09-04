//
//  EventVM.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import Foundation
import Firebase

final class EventVM: ObservableObject, Identifiable, Hashable {
    
    let loggedInUser = AccountViewModel.shared
    @Published var event: Event = .empty
    
    
    init(event: Event = .empty) {
        self.event = event
    }
    
    var isValid: Bool {
        !self.event.name.isEmpty &&
        !self.event.description.isEmpty
    }
    
    static func == (lhs: EventVM, rhs: EventVM) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
  
}

extension EventVM {
    
    func addAdmin(uid: String) {
        var creator = EventMember(firstname: self.loggedInUser.firstname, lastname: self.loggedInUser.lastname, role: EventMember.Role.administrator, accepted: true, inwaiting: false, refused: false)
        creator.id = uid
        self.event.members.append(creator)
    }
}

extension EventVM {
    func update() {
        let dbEventRef: DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("evenements")
                .child(self.event.id)
            return ref
        }()
        
        guard let usurId = Auth.auth().currentUser?.uid else {
          return
        }
        // Adding the admin of the event
        self.addAdmin(uid: usurId)
        var dataDict = self.event.dictionary
        dataDict?["id"] = self.event.id
        dataDict?["id_administrateur"] = usurId
        
        do {
          let encoder = JSONEncoder()

          encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

          let data = try encoder.encode(self.event)
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
        let dbEventRef: DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("evenements")
            return ref
        }()
        
        guard let usurId = Auth.auth().currentUser?.uid else {
          return
        }
        

        // Adding the admin of the event
        self.addAdmin(uid: usurId)
        self.event.startTime = self.event.startDate.toString(format: "HH:mm")
        self.event.endTime = self.event.endDate.toString(format: "HH:mm")
        var dataDict = self.event.dictionary
        
        dataDict?["id_administrateur"] = usurId
        //1
        let newEventRef = dbEventRef.childByAutoId()
        
        let newEventId = newEventRef.key
        
        dataDict?["id"] = newEventId
        
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

extension EventVM {
    func delete() {
        let dbRefToSelectedItem : DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("evenements")
                .child(self.event.id)
            return ref
        }()
//        print(self.id)
        dbRefToSelectedItem.removeValue()
    }
    
    
    func accept() {
        var user = self.event.members.filter({ $0.firstname == self.loggedInUser.firstname &&  $0.lastname == self.loggedInUser.lastname}).first
        
        if user != nil {
            user?.accepted = true
            self.update()
        }
    }
    
    func refuse() {
        var user = self.event.members.filter({ $0.firstname == self.loggedInUser.firstname &&  $0.lastname == self.loggedInUser.lastname}).first
        if user != nil {
            user?.refused = true
            self.update()
        }
    }
    
    var isInwaiting: Bool{
        if let user = self.event.members.filter({ $0.firstname == self.loggedInUser.firstname &&  $0.lastname == self.loggedInUser.lastname}).first {
            return user.inwaiting
        }
        return false
    }
    
    var organizer: String {
        if let user = self.event.members.filter({ $0.id == self.event.idAdministrateur}).first {
            return "\(user.firstname) \(user.lastname)"
        }
        return ""
    }
    
    var admin: String {
        let x = self.event.members.filter({ $0.id == self.loggedInUser.uid })
        return "\(x.first?.firstname ?? "") \(x.first?.lastname ?? "")"
    }
}
