//
//  Date.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import Foundation


extension Date {
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}
        
        return localDate
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }
}
