//
//  GroupMember.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import Foundation

struct GroupMember: Codable, Identifiable, Hashable {
    var id: String
    var firstname: String
    var lastname: String
    var birthdate: String
    var role: EventMember.Role

    init(uid: String, firstname: String, lastname: String, birthdate: String, role: EventMember.Role){
        self.id = uid
        self.firstname = firstname
        self.lastname = lastname
        self.birthdate = birthdate
        self.role = role
    }
    

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case birthdate = "naissanceMembre"
        case firstname = "prenom"
        case lastname = "nom"
        case role = "role"
    }
    
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        firstname = try container.decode(String.self, forKey: .firstname)
        lastname = try container.decode(String.self, forKey: .lastname)
        birthdate = try container.decode(String.self, forKey: .birthdate)
        role = try container.decode(EventMember.Role.self, forKey: .role)
     }
}


extension GroupMember {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstname, forKey: .firstname)
        try container.encode(lastname, forKey: .lastname)
        try container.encode(birthdate, forKey: .birthdate)
        try container.encode(role, forKey: .role)
    }
}

extension GroupMember {
    static var empty: GroupMember {
        return GroupMember(uid: UUID().uuidString, firstname: "", lastname: "", birthdate: "", role: EventMember.Role.administrator)
    }
}

