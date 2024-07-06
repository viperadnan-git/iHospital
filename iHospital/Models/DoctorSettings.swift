//
//  DoctorSettings.swift
//  iHospital
//
//  Created by Adnan Ahmad on 06/07/24.
//

import Foundation


struct DoctorSettings: Codable {
    let userId: UUID
    let priorBookingDays: Int
    let startTime: Date
    let endTime: Date
    let selectedDays: [String]
    let fee: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case priorBookingDays = "prior_booking_days"
        case startTime = "start_time"
        case endTime = "end_time"
        case selectedDays = "selected_days"
        case fee
    }
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(priorBookingDays, forKey: .priorBookingDays)
        try container.encode(DoctorSettings.timeFormatter.string(from: startTime), forKey: .startTime)
        try container.encode(DoctorSettings.timeFormatter.string(from: endTime), forKey: .endTime)
        try container.encode(selectedDays, forKey: .selectedDays)
        try container.encode(fee, forKey: .fee)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(UUID.self, forKey: .userId)
        priorBookingDays = try container.decode(Int.self, forKey: .priorBookingDays)
        
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        
        guard let startTime = DoctorSettings.timeFormatter.date(from: startTimeString.prefix(8).description),
              let endTime = DoctorSettings.timeFormatter.date(from: endTimeString.prefix(8).description) else {
            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Invalid time format")
        }

        self.startTime = startTime
        self.endTime = endTime
        selectedDays = try container.decode([String].self, forKey: .selectedDays)
        fee = try container.decode(Int.self, forKey: .fee)
    }
    
    init(userId: UUID, priorBookingDays: Int, startTime: Date, endTime: Date, selectedDays: [String], fee: Int) {
        self.userId = userId
        self.priorBookingDays = priorBookingDays
        self.startTime = startTime
        self.endTime = endTime
        self.selectedDays = selectedDays
        self.fee = fee
    }
    

    static func get(userId: UUID) async throws -> DoctorSettings {
        let response = try? await supabase.from("doctor_settings")
            .select()
            .eq("user_id", value: userId)
            .single()
            .execute()
        
        guard let response = response else {
            let startTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
            let endTime = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
            let selectedDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
            
            return DoctorSettings(
                userId: userId,
                priorBookingDays: 7,
                startTime: startTime,
                endTime: endTime,
                selectedDays: selectedDays,
                fee: 499
            )
        }
        
        print(String(data: response.data, encoding: .utf8) ?? "No data")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            if let date = DoctorSettings.timeFormatter.date(from: dateStr.prefix(8).description) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        
        return try decoder.decode(DoctorSettings.self, from: response.data)
    }
}
