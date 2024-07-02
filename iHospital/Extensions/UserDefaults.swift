//
//  UserDefaults.swift
//  iHospital
//
//  Created by Adnan Ahmad on 01/07/24.
//

import Foundation

extension UserDefaults {
    func saveObject<T: Encodable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(object) else {
            print("Failed to encode object of type \(T.self)")
            return
        }
        
        set(data, forKey: key)
    }
    
    func getObject<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else {
            print("No data found for key: \(key)")
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Failed to decode object of type \(T.self)")
            return nil
        }
        
        return object
    }
}
