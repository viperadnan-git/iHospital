//
//  BloodGroup.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import Foundation

enum BloodGroup: String, Codable, CaseIterable {
    case APositive = "A+"
    case ANegative = "A-"
    case BPositive = "B+"
    case BNegative = "B-"
    case ABPositive = "AB+"
    case ABNegative = "AB-"
    case OPositive = "O+"
    case ONegative = "O-"
    case Unknown = "Unknown"
    
    /// Returns the raw value of the blood group as a string
    var id: String {
        self.rawValue
    }
}
