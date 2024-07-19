//
//  DateFormatter.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 04/07/24.
//

import Foundation

extension DateFormatter {
    /// Provides a date formatter with a short date style
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    /// Provides a time formatter with "HH:mm:ss" format and GMT timezone
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    /// Provides a date formatter with "yyyy-MM-dd" format
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

