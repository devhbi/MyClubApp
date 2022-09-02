//
//  Member.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 01/09/2022.
//

import Foundation

struct Member: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var birthDate: Date?
    var city: String
    var zipcode: String
    var street: String
    var globalAdmin: String
    var admin: String
    var superuser: String
    var userType: String
    var phone: String
    var repassword: String = ""
    
    init(firstname: String, lastname: String, email: String, password: String, birthDate: Date, city: String, zipcode: String, street: String, globalAdmin: String, admin: String, superuser: String, userType: String, phone: String){
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.password = password
        self.birthDate = birthDate
        self.city = city
        self.zipcode = zipcode
        self.street = street
        self.globalAdmin = globalAdmin
        self.admin = admin
        self.superuser = superuser
        self.userType = userType
        self.phone = phone
    }
    
    private enum CodingKeys: String, CodingKey {
//        case id = "id"
        case firstname = "prenom"
        case lastname = "nom"
        case email = "email"
        case password = "password"
        case birthDate = "dateNaissance"
        case city = "ville"
        case zipcode = "codepostal"
        case street = "rue"
        case globalAdmin = "administrateurglobal"
        case admin = "administrateur"
        case superuser = "superUtilisateur"
        case userType = "typeUtilisateur"
        case phone = "telephone"
    }
    
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Extract studentId from coding path
        if container.codingPath.first != nil {
            self.id = container.codingPath.first!.stringValue
        }
        
        self.firstname = try container.decode(String.self, forKey: .firstname)
        self.lastname = try container.decode(String.self, forKey: .lastname)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
        self.birthDate = try container.decode(Date.self, forKey: .birthDate, dateFormatter: .onlydate)
        self.city = try container.decode(String.self, forKey: .city)
        self.zipcode = try container.decode(String.self, forKey: .zipcode)
        self.street = try container.decode(String.self, forKey: .street)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.globalAdmin = try container.decode(String.self, forKey: .globalAdmin)
        self.admin = try container.decode(String.self, forKey: .admin)
        self.superuser = try container.decode(String.self, forKey: .superuser)
        self.userType = try container.decode(String.self, forKey: .userType)
     }
}

extension Member {
    static var empty: Member {
        return Member(firstname: "", lastname: "", email: "", password: "", birthDate: Date.now, city: "", zipcode: "", street: "", globalAdmin: "inactif", admin: "inactif", superuser: "inactif", userType: "inactif", phone: "")
    }
}

extension Member {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstname, forKey: .firstname)
        try container.encode(lastname, forKey: .lastname)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(birthDate ?? Date.now, forKey: .birthDate, dateFormatter: .onlydate)
        try container.encode(city, forKey: .city)
        try container.encode(zipcode, forKey: .zipcode)
        try container.encode(street, forKey: .street)
        try container.encode(globalAdmin, forKey: .globalAdmin)
        try container.encode(admin, forKey: .admin)
        try container.encode(superuser, forKey: .superuser)
        try container.encode(userType, forKey: .userType)
        try container.encode(phone, forKey: .phone)
    }
}


extension Member {
    var fullname: String {
        return "\(self.firstname) \(self.lastname)"
    }
    
    var role: String {
        if self.isSuperAdministrator {
            return "Super-Administrateur"
        }
        else if self.isAdministrator {
            return "Administrateur"
        }
        else if self.isEducator {
            return "Éducateur"
        }
        return "Membre"
    }
    
}

extension Member {
    var isSuperAdministrator: Bool {
        get {
            return self.superuser == "actif"
        }
        set {
            if newValue {
                self.superuser = "actif"
                self.admin = "inactif"
                self.globalAdmin = "inactif"
            }
            else {
                self.superuser = "inactif"
                self.admin = "inactif"
                self.globalAdmin = "inactif"
            }
        }
    }
    
    var isAdministrator: Bool {
        get {
            return self.globalAdmin == "actif"
        }
        set {
            if newValue {
                self.globalAdmin = "actif"
                self.superuser = "inactif"
                self.admin = "inactif"
            }
            else {
                self.superuser = "inactif"
                self.admin = "inactif"
                self.globalAdmin = "inactif"
            }
        }
    }
    
    var isEducator: Bool {
        get {
            return self.admin == "actif"
        }
        set {
            if newValue {
                self.admin = "actif"
                self.superuser = "inactif"
                self.globalAdmin = "inactif"
            }
            else {
                self.superuser = "inactif"
                self.globalAdmin = "inactif"
                self.admin = "inactif"
            }
        }
    }
    
    var isMember: Bool {
        get {
            return !self.isSuperAdministrator && !self.isAdministrator && !self.isEducator
        }
        set {
            if newValue {
                self.globalAdmin = "inactif"
                self.admin = "inactif"
                self.superuser = "inactif"
            }
        }
    }
}
