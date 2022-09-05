//
//  EventListVM.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import Foundation
import Firebase

final class EventListVM: ObservableObject {
    @Published var eventVMs: [EventVM] = [EventVM]()
    
    private lazy var databasePath: DatabaseReference? = {
        let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
        let ref = Database.database()
            .reference()
            .child(dbname)
            .child("evenements")
        return ref
    }()
    
    init() {
        load()
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
                let dict = try JSONDecoder().decode([String: Event].self, from: data)
                let events = dict.map {$0.value}.filter { !$0.members.isEmpty && $0.members.map{$0.id}[0] == userId }
                self.eventVMs = events.map {EventVM(event: $0)}
                print(events)
            }
            catch {
                print(error)
            }
        })
    }
}
