//
//  String.swift
//  iHospital
//
//  Created by Adnan Ahmad on 08/07/24.
//

import Foundation


extension String {
    var isAlphabetsAndSpaces: Bool {
        return !isEmpty && range(of: "[^a-zA-Z ]", options: .regularExpression) == nil
    }
    
    var isAlphabets: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
        
    }
    
    var isPhoneNumber: Bool {
        return !isEmpty && range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
