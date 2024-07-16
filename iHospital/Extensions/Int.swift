//
//  Int.swift
//  iHospital
//
//  Created by Adnan Ahmad on 10/07/24.
//

extension Int {
    var string: String {
        String(self)
    }
    
    var currency: String {
        self.formatted(.currency(code: Constants.currencyCode))
    }
}
