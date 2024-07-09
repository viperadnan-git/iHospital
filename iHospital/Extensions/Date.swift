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
        let calendar = Calendar.current
        let currentMinutes = calendar.component(.minute, from: self)
        let remainder = currentMinutes % 15
        let minutesToAdd = 15 - remainder
        guard let nextQuarterDate = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) else {
            return self
        }
        let nextQuarterMinutes = calendar.component(.minute, from: nextQuarterDate)
        
        let adjustedHour = calendar.component(.hour, from: self) + (nextQuarterMinutes / 60)
        let adjustedMinutes = nextQuarterMinutes % 60
        
        return calendar.date(bySettingHour: adjustedHour, minute: adjustedMinutes, second: 0, of: self) ?? self
    }
    
    var yearsSince: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self, to: Date())
        return components.year ?? 0
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
