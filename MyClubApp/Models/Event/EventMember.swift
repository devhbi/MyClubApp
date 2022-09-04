//
//  EventMember.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import Foundation


struct EventMember: Codable, Identifiable, Hashable {
    var id: String?
    var firstname: String
    var lastname: String
    var role: EventMember.Role
    var accepted: Bool = false
    var inwaiting: Bool = true
    var refused: Bool = false

    init(firstname: String, lastname: String, role: EventMember.Role, accepted: Bool, inwaiting: Bool, refused: Bool){
        self.firstname = firstname
        self.lastname = lastname
        self.role = role
        self.accepted = accepted
        self.inwaiting = inwaiting
        self.refused = refused
    }

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstname = "nom"
        case lastname = "prenom"
        case role = "role"
        case accepted = "accepte"
        case inwaiting = "en_attente"
        case refused = "refuse"
    }
    
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        firstname = try container.decode(String.self, forKey: .firstname)
        lastname = try container.decode(String.self, forKey: .lastname)
        role = try container.decode(EventMember.Role.self, forKey: .role)
        accepted = try container.decode(Bool.self, forKey: .accepted)
        inwaiting = try container.decode(Bool.self, forKey: .inwaiting)
        refused = try container.decode(Bool.self, forKey: .refused)
     }

}

extension EventMember {
    init(_ groupMember: GroupMember) {
        self.id = groupMember.id
        self.firstname = groupMember.firstname
        self.lastname = groupMember.lastname
        self.role = EventMember.Role.member
    }
}

extension EventMember {
    static var empty: EventMember {
        return EventMember(firstname: "", lastname: "", role: EventMember.Role.allCases.first!, accepted: false, inwaiting: false, refused: false)
    }
}

extension EventMember {
    enum MatchType: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case amical = "Amical"
        case national = "National"
        case regional = "Régional"
        case na = "Autre"
    }
}

extension EventMember {
    enum Role: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case administrator = "administrateur"
        case responsable = "responsable"
        case educateur = "educateur"
        case member = "membre"
        case na = "Autre"
    }
}

extension EventMember {
    enum Repetition: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case everyweek = "Chaque semaine"
        case everymonth = "Chaque mois"
        case everysemester = "Chaque trimestre"
        case na = "Autre"
    }
}


extension EventMember {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstname, forKey: .firstname)
        try container.encode(lastname, forKey: .lastname)
        try container.encode(role, forKey: .role)
        try container.encode(accepted, forKey: .accepted)
        try container.encode(inwaiting, forKey: .inwaiting)
        try container.encode(refused, forKey: .refused)
    }
}
