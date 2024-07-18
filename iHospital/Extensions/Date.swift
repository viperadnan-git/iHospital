//
//  Date.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 08/07/24.
//

import Foundation

extension Date {
    var yearsSince: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    var ago: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        if years > 0 {
            return "\(years) year\(years == 1 ? "" :"s")"
        } else if months > 0 {
            return "\(months) month\(months == 1 ? "" :"s")"
        } else {
            return "\(days) day\(days == 1 ? "" :"s")"
        }
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
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self.startOfDay)!
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var dateTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var localDate: Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    static var RANGE_MIN_24_YEARS_OLD: PartialRangeThrough<Date> {
        ...Calendar.current.date(byAdding: .year, value: -24, to: Date())!
    }
    
    static var RANGE_MIN_18_YEARS_OLD: PartialRangeThrough<Date> {
        ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    }
    
    static var RANGE_MAX_60_YEARS_AGO: ClosedRange<Date> {
        Calendar.current.date(byAdding: .year, value: -60, to: Date())!...Date()
    }
}
