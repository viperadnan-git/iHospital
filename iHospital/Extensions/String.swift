//
//  String.swift
//  iHospital
//
//  Created by Adnan Ahmad on 08/07/24.
//

import Foundation

extension String {
    /// Checks if the string contains only alphabets and spaces
    var isAlphabetsAndSpaces: Bool {
        !isEmpty && range(of: "[^a-zA-Z ]", options: .regularExpression) == nil
    }
    
    /// Checks if the string contains only alphabets
    var isAlphabets: Bool {
        !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    /// Validates if the string is a valid email address
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// Checks if the string is a valid 10-digit phone number
    var isPhoneNumber: Bool {
        !isEmpty && range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }
    
    /// Trims whitespace and newlines from the string
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

