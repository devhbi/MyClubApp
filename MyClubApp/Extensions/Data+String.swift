//
//  Data+String.swift
//  MyClubApp
//
//  Created by Pole Star on 02/09/2022.
//

import Foundation


extension Date {
    func toString (format: String) -> String {
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = format

        // Convert Date to String
        return dateFormatter.string(from: self)
    }
    
    
    func mois () -> String {
        // Create Date Formatter
        let formatter = DateFormatter()
        
        // Set Date Format
        formatter.dateFormat = "LLLL"
        
        formatter.locale = Locale(identifier: "fr_FR") // French from France
        
        // Convert Date to String
        return formatter.string(from: self)
    }
    
    
    func jour () -> String {
        // Create Date Formatter
        let formatter = DateFormatter()
        
        // Set Date Format
        formatter.dateFormat = "LLLL"
        
        formatter.locale = Locale(identifier: "fr_FR") // French from France
        
        // Convert Date to String
        return formatter.string(from: self)
    }
}

extension String {
    func fromString (format: String) -> Date {
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX

        // Set Date Format
        dateFormatter.dateFormat = format

        // Convert String to Date
        return dateFormatter.date(from: self) ?? Date()
    }
}
