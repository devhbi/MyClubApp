//
//  ClubModelController.swift
//  MyClubApp
//
//  Created by polestar on 06/09/2022.
//

import Foundation

// MARK: - ClubDataModel
struct ClubDataModel: Codable, Identifiable, Hashable {
    var id : String = UUID().uuidString
    let name: String
}

typealias Clubs = [ClubDataModel]

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try?decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the project")
        }
        
        return loadedData
    }
}

class ClubModelController: ObservableObject {
    @Published var allClubs: Clubs
    @Published var clubs: [String]
    
    static let shared = ClubModelController()
    
    private init() {
        let array: Clubs = Bundle.main.decode(file: "clubsfrance.json")
        self.allClubs = array
        self.clubs = array.map { (club) -> String in club.name}
        
//        print(self.clubs)
    }
}
