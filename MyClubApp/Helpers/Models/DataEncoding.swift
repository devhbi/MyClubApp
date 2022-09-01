//
//  DataEncoding.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 01/09/2022.
//

import Foundation

extension KeyedDecodingContainerProtocol {
    
    func decode(_ type: Date.Type, forKey key: Self.Key, dateFormatter formatter: DateFormatter) throws -> Date {
        let dateString = try decode(String.self, forKey: key)
        return try parse(dateString, from: key, with: formatter)
    }
     
    func decodeIfPresent(_ type: Date.Type, forKey key: Self.Key, dateFormatter formatter: DateFormatter) throws -> Date? {
        guard let dateString = try decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        return try parse(dateString, from: key, with: formatter)
    }
     
    private func parse(_ dateString: String, from key: Self.Key, with formatter: DateFormatter) throws -> Date {
        if  let date = formatter.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(forKey: key,
                    in: self,
                    debugDescription: "Wrong Date Format")
        }
    }
}

extension KeyedEncodingContainerProtocol {
    public mutating func encode(_ date: Date, forKey key: Self.Key, dateFormatter formatter: DateFormatter) throws {
        try encodeIfPresent(date, forKey: key, dateFormatter: formatter)
    }
 
    public mutating func encodeIfPresent(_ date: Date?, forKey key: Self.Key, dateFormatter formatter: DateFormatter) throws {
        if let d = date {
            let dateString: String = formatter.string(from: d)
            try encode(dateString, forKey: key)
        }
    }
}

extension DateFormatter {
    static let onlydate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
}

extension DateFormatter {
    static let datetime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter
    }()
    
    static let onlytime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH\\hmm"
        return formatter
    }()
}

extension Encodable {
    var dictionary: [String: Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
