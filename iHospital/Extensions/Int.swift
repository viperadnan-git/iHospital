//
//  Int.swift
//  iHospital
//
//  Created by Adnan Ahmad on 10/07/24.
//

import Foundation

extension Int {
    /// Converts the integer to a string representation
    var string: String {
        String(self)
    }
    
    /// Converts the integer to a currency string using the specified currency code
    var currency: String {
        self.formatted(.currency(code: Constants.currencyCode))
    }
}

