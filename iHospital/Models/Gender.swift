//
//  Gender.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//


enum Gender:String, Codable, CaseIterable {
    case male = "male"
    case female = "female"
    case others = "others"
    
    var id: String {
        self.rawValue
    }
}
