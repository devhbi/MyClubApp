//
//  GroupModel.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import Foundation


struct GroupModel: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var link: String = ""
    var visibility: GroupModel.Visibility
    var audiance: Event.Audiance
    var members: [String:GroupMember]
    
    var ids: [String] {
        members.map{String($0.key) }
    }

    init(name: String, link: String, visibility: GroupModel.Visibility, audiance: Event.Audiance, members: [String:GroupMember]){
        self.name = name
        self.link = link
        self.visibility = visibility
        self.audiance = audiance
        self.members = members
    }
    

    private enum CodingKeys: String, CodingKey {
        case id = "idGroupe"
        case name = "nomGroupe"
        case link = "lien"
        case audiance = "age"
        case visibility = "visibilite"
        case members = "lesMembres"
    }
    
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        link = try container.decode(String.self, forKey: .link)
        audiance = try container.decode(Event.Audiance.self, forKey: .audiance)
        visibility = try container.decode(GroupModel.Visibility.self, forKey: .visibility)
        do {
            self.members = try container.decode([String:GroupMember].self, forKey: .members)
        }
        catch {
            print("Load members failed with error: \(error)")
            self.members = [String:GroupMember]()
        }
     }
}

extension GroupModel {
    enum Visibility: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case Total = "Total"
        case total = "total"
        case administrateurs = "Administrateurs"
        case na = "Autre"
    }
}

extension GroupModel {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(link, forKey: .link)
        try container.encode(audiance, forKey: .audiance)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(members, forKey: .members)
    }
}

extension GroupModel {
    static var empty: GroupModel {
        
        return GroupModel(name: "", link: "", visibility: GroupModel.Visibility.allCases.first!, audiance: Event.Audiance.allCases.first!, members: [String:GroupMember]())
    }
}
