//
//  Date.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import Foundation


extension Date {
    var localDate: Date {
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
    
    var nextQuarter: Date {
        // select next 15, 30, 45, 60 minutes
        let minutes = Calendar.current.component(.minute, from: self)
        let nextQuarter = (minutes / 15 + 1) * 15
        return Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: self), minute: nextQuarter, second: 0, of: self)!
    }
}
