//
//  MedicalRecord.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

struct MedicalRecord: Codable, Identifiable {
    var id: Int
    var note: String
    var imagePath: String
    var medicines: [String]
    var appointment: Appointment
    var patient: Patient
    
    enum CodingKeys: String, CodingKey {
        case id
        case note
        case imagePath = "image_path"
        case medicines
        case appointment
        case patient
    }
    
    static let supabaseSelectQuery = "*, appointment:appointment_id(\(Appointment.supabaseSelectQuery)), patient:patient_id(*)"
    
    static let sample = MedicalRecord(id: 1, note: "Prescription Note", imagePath: "pencil_note.jpg", medicines: ["Medicine 1", "Medicine 2"], appointment: Appointment.sample, patient: Patient.sample)
    
    /// Loads the image associated with the medical record
    /// - Returns: The image data
    func loadImage() async throws -> Data {
        try await supabase.storage.from(SupabaseBucket.medicalRecords.id).download(path: imagePath)
    }
}
