//
//  GroupListVM.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 05/09/2022.
//

import Foundation
import Firebase
import UIKit

final class GroupListVM: ObservableObject {
    @Published var groupListVM = [GroupVM]()
    
    private lazy var databasePath: DatabaseReference? = {
        let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
        let ref = Database.database()
            .reference()
            .child(dbname)
            .child("groupes")
        return ref
    }()
    
    var myGroupIndexes: [Int] {
        guard let userId = Auth.auth().currentUser?.uid else {
          return []
        }
        return self.groupListVM
            .enumerated()
            .filter { $0.element.group.members.map{$0.key}[0] == userId }
            .map({ $0.offset })
    }
    
    
    var myGroups: [GroupVM] {
        guard let userId = Auth.auth().currentUser?.uid else {
          return []
        }
        
        return self.groupListVM.filter { !$0.group.members.isEmpty && $0.group.members.map{$0.key}[0] == userId }
    }
    
    init() {
        self.load()
    }
    
    func load() {
        guard let databasePath = self.databasePath else {
          return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
          return
        }
        
        databasePath.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }

            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                let dict = try JSONDecoder().decode([String: GroupModel].self, from: data)
                let groups = dict.map {$0.value}.filter { !$0.members.isEmpty && $0.members.keys.contains(userId) }
                self.groupListVM = groups.map {GroupVM(group: $0)}
                
//                print("####################################")
//                print(self.results)
//                print("####################################")
            }
            catch {
                print(error)
            }
        })
        
        
    }
}
