//
//  String.swift
//  iHospital
//
//  Created by Adnan Ahmad on 02/07/24.
//

import Foundation

let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let EMAIL_PREDICATE = NSPredicate(format:"SELF MATCHES %@", EMAIL_REGEX)

extension String {
    var isValidEmail:Bool {
        return EMAIL_PREDICATE.evaluate(with: self)
    }
}
