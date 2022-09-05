//
//  Event.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import Foundation
import Firebase

struct Event: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var chrono: String = ""
    var name: String
    var group: String
    var startDate: Date
    var startTime: String
    var endDate: Date
    var endTime: String
    var link: String = ""
    var idAdministrateur: String
    var typeMatch: MatchType
    var description: String = ""
    var termine: String = ""
    var opposingTeam: String = ""
    var installation: String = ""
    var repetition: String = ""
    var lieu: String = ""
    var idGroupe: String = ""
    var idMatch: String = ""
    var type: EventType
    var visibility: Event.Visibility = Event.Visibility.epublic
    var frequency: Event.ActionTimingType = Event.ActionTimingType.once
    var typeAction: Event.ActionType = Event.ActionType.event
    var members: [EventMember]
    

    
    init(name: String, group: String, startDate: Date, endDate: Date, description: String, type: EventType, typeMatch: MatchType, idAdministrateur: String, members: [EventMember]){
        self.name = name
        self.group = group
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startDate.toString(format: "HH:mm")
        self.endTime = endDate.toString(format: "HH:mm")
        self.idAdministrateur = idAdministrateur
        self.type = type
        self.typeMatch = typeMatch
        self.description = description
        self.members = members
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case chrono = "chrono"
        case name = "nom"
        case group = "groupe"
        case startDate = "datedebut"
        case startTime = "heuredebut"
        case endDate = "datefin"
        case endTime = "heurefin"
        case idAdministrateur = "id_administrateur"
        case typeMatch = "type_match"
        case opposingTeam = "club_adverse"
        case type = "type_evenements"
        case termine = "termine"
        case installation = "installation"
        case repetition = "repetition"
        case lieu = "lieu"
        case description = "descriptions"
        case members = "lesMembres"
        case link = "lien"
        case idGroupe = "id_groupe"
        case idMatch = "id_match"
    }
    
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        group = try container.decode(String.self, forKey: .group)
        termine = try container.decode(String.self, forKey: .termine)
        installation = try container.decode(String.self, forKey: .installation)
        repetition = try container.decode(String.self, forKey: .repetition)
        lieu = try container.decode(String.self, forKey: .lieu)
        opposingTeam = try container.decode(String.self, forKey: .opposingTeam)
        startDate = try container.decode(Date.self, forKey: .startDate, dateFormatter: .onlydate)
        
        do {
            startTime = try container.decode(String.self, forKey: .startTime)
        }
        catch {
            startTime = Date.now.toString(format: "HH:mm")
        }
//        endDate = try container.decode(Date.self, forKey: .endDate, dateFormatter: .onlydate)
        do {
            endDate = try container.decode(Date.self, forKey: .endDate, dateFormatter: .onlydate)
        }
        catch {
            endDate = Date.now
        }
        
//        endTime = try container.decode(String.self, forKey: .endTime)
        do {
            endTime = try container.decode(String.self, forKey: .endTime)
        }
        catch {
            endTime = Date.now.toString(format: "HH:mm")
        }
//        endTime = try container.decode(Date.self, forKey: .endTime, dateFormatter: .onlytime)
        idAdministrateur = try container.decode(String.self, forKey: .idAdministrateur)
        type = try container.decode(EventType.self, forKey: .type)
        typeMatch = try container.decode(MatchType.self, forKey: .typeMatch)
//        description = try container.decode(String.self, forKey: .description)
        do {
            description = try container.decode(String.self, forKey: .description)
        }
        catch {
        }
        link = try container.decode(String.self, forKey: .link)
        idGroupe = try container.decode(String.self, forKey: .idGroupe)
        idMatch = try container.decode(String.self, forKey: .idMatch)
        do {
            self.members = try container.decode([EventMember].self, forKey: .members)
        }
        catch {
            self.members = [EventMember]()
        }
     }
}

extension Event {
    mutating func addMembers(from members: [GroupMember]) {
        for member in members {
            let participant = EventMember(member)
            self.members.append(participant)
        }
    }
}

extension Event {
    enum EventType: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case match = "Match"
        case training = "Entrainements"
    }
}

extension Event {
    enum ActionType: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case event = "Event"
        case message = "Message"
    }
}

extension Event {
    enum ActionTimingType: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case periodic = "Periodic"
        case once = "Once"
    }
}

extension Event {
    enum ActionFrequency: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case weekly  = "Chaque semaine"
        case fortnightly = "Toutes les deux semaines"
        case monthly = "Tous les mois"
    }
}

extension Event {
    enum MatchType: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case official = "Match officiel"
        case friendly = "Match amical"
        case plateau = "Plateau"
        case tournament = "Tournoi"
        case na = "Autre"
    }
    
}

extension Event {
    enum Visibility: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case epublic = "Public"
        case eprivate = "Privé"
        case total = "total"
    }
}

extension Event {
    enum Audiance: String, Identifiable, CaseIterable, Decodable, Encodable {
        var id: Self{self}
        case jeunes = "Jeunes"
        case adultes = "Adultes"
        case adulte = "adulte"
        case educateurs = "Educateurs"
        case responsables = "Responsables"
        case administrateurs = "Administrateurs"
        case mixte = "Mixte"
        case na = "Tous le monde"
    }
}

extension Event {
    static var empty: Event {
        return Event(name: "", group: "", startDate: Date.now, endDate: Date.now, description:"", type: EventType.allCases.first!, typeMatch: MatchType.allCases.first!,idAdministrateur: "", members: [EventMember]())
    }
}

extension Event {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(group, forKey: .group)
        try container.encode(termine, forKey: .termine)
        try container.encode(installation, forKey: .installation)
        try container.encode(lieu, forKey: .lieu)
        try container.encode(opposingTeam, forKey: .opposingTeam)
        try container.encode(repetition, forKey: .repetition)
        try container.encode(startDate, forKey: .startDate, dateFormatter: .onlydate)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endDate, forKey: .endDate, dateFormatter: .onlydate)
//        try container.encode(endTime, forKey: .endTime, dateFormatter: .onlytime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(idAdministrateur, forKey: .idAdministrateur)
        try container.encode(type, forKey: .type)
        try container.encode(typeMatch, forKey: .typeMatch)
        try container.encode(description, forKey: .description)
        try container.encode(members, forKey: .members)
        try container.encode(link, forKey: .link)
        try container.encode(idGroupe, forKey: .idGroupe)
        try container.encode(idMatch, forKey: .idMatch)
    }
}

extension Event {
    var accepted: Int {
        return self.members.filter({ $0.accepted == true }).count
    }
    
    var inwaiting: Int {
        return self.members.filter({ $0.inwaiting == true }).count
    }
    
    var refused: Int {
        return self.members.filter({ $0.refused == true }).count
    }
}



