//
//  MemberListVM.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 03/09/2022.
//

import Foundation
import Firebase


final class MemberListVM: ObservableObject {
    @Published var memberVMs: [MemberVM] = [MemberVM]()
    
    private lazy var databasePath: DatabaseReference? = {
        let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
        let ref = Database.database()
            .reference()
            .child(dbname)
            .child("users")
        return ref
    }()
    
    func load() {
        guard let databasePath = self.databasePath else {
          return
        }
        
        databasePath.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                let dict = try JSONDecoder().decode([String: Member].self, from: data)
                self.memberVMs = dict.map {MemberVM(member: $0.value)}
//                print(dict)
            }
            catch {
                print(error)
            }
        })
    }
    
    static func update(model: Member) {
        let dbUserRef: DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("users")
                .child(model.id)
            return ref
        }()
        
        let dataDict = model.dictionary
        // 2
        dbUserRef.setValue(dataDict) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }

            // 3
            DispatchQueue.main.async {
                dbUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        print(userDict.debugDescription)
                    }
                })
            }
        }
    }
}


