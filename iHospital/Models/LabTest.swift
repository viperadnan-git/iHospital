//
//  LabTest.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

class LabTest: Codable, Identifiable {
    let id: Int
    let test: LabTestType
    let patient: Patient
    var status: LabTestStatus
    let appointment: Appointment
    var sampleID: String?
    var reportPath: String?
    
    var reportName: String {
        return URL(string: reportPath ?? "")?.lastPathComponent ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case test
        case patient
        case status
        case appointment
        case sampleID = "sample_id"
        case reportPath = "report_path"
    }
    
    static let supabaseSelectQuery = "*, test:test_id(*), patient:patient_id(*), appointment:appointment_id(\(Appointment.supabaseSelectQuery))"
    
    static let sample = LabTest(id: 1, test: LabTestType.sample, patient: Patient.sample, status: .pending, appointment: Appointment.sample, sampleID: nil, reportPath: nil)
    
    /// Initializes a new LabTest object
    init(id: Int, test: LabTestType, patient: Patient, status: LabTestStatus, appointment: Appointment, sampleID: String?, reportPath: String?) {
        self.id = id
        self.test = test
        self.patient = patient
        self.status = status
        self.appointment = appointment
        self.sampleID = sampleID
        self.reportPath = reportPath
    }

    /// Downloads the lab test report
    /// - Returns: The URL of the downloaded report
    func downloadReport() async throws -> URL {
        guard let reportPath = self.reportPath else {
            throw SupabaseError.invalidData
        }
        
        let fileName = "\(id)_\(reportName)"
        
        if let url = FileManager.tempFileExists(fileName: fileName) {
            return url
        }
        
        let response = try await supabase.storage.from(SupabaseBucket.labReports.id).download(path: reportPath)
        
        let url = try FileManager.saveToTempDirectory(fileName: fileName, data: response)
        
        return url
    }
}

enum LabTestStatus: String, Codable, CaseIterable {
    case pending
    case waiting
    case inProgress = "in-progress"
    case completed

    /// Returns the color associated with the lab test status
    var color: Color {
        switch self {
        case .pending:
            return .yellow
        case .waiting:
            return .purple
        case .inProgress:
            return .blue
        case .completed:
            return .green
        }
    }
}
