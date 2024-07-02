//
//  Date.swift
//  iHospital
//
//  Created by Adnan Ahmad on 02/07/24.
//

import Foundation


extension Date {
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}
        
        return localDate
    }
}
