//
//  Invoice.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

enum PaymentType: String, Codable {
    case appointment
    case labTest = "lab_test"
    case bed
    
    var name: String {
        switch self {
        case .appointment:
            return "Appointment"
        case .labTest:
            return "Lab Test"
        case .bed:
            return "Bed"
        }
    }
}

struct Invoice: Identifiable, Codable {
    var id: Int
    var createdAt: Date
    var patient: Patient
    var userID: UUID
    var amount: Int
    var paymentType: PaymentType
    var referenceId: Int
    var status: PaymentStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case patient
        case userID = "user_id"
        case amount
        case paymentType = "payment_type"
        case referenceId = "reference_id"
        case status
    }
    
    static let supabaseSelectQuery = "*, patient:patient_id(*)"
    
    static let sample = Invoice(id: 1,
                                createdAt: Date(),
                                patient: Patient.sample,
                                userID: UUID(),
                                amount: 100,
                                paymentType: .appointment,
                                referenceId: 1,
                                status: .pending)
    
    func fetchReferencedObject() async throws -> Any {
        switch paymentType {
        case .appointment:
            return try await fetchAppointment(referenceId: referenceId)
        case .labTest:
            return try await fetchLabTest(referenceId: referenceId)
        case .bed:
            return try await fetchBedBooking(referenceId: referenceId)
        }
    }
    
    private func fetchAppointment(referenceId: Int) async throws -> Appointment {
        let response:Appointment = try await supabase.from(SupabaseTable.appointments.id)
            .select(Appointment.supabaseSelectQuery)
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    private func fetchLabTest(referenceId: Int) async throws -> LabTest {
        let response:LabTest = try await supabase.from(SupabaseTable.labTests.id)
            .select(LabTest.supabaseSelectQuery)
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    private func fetchBedBooking(referenceId: Int) async throws -> BedBooking {
        let response:BedBooking = try await supabase.from(SupabaseTable.bedBookings.id)
            .select()
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    // this is for demonstartin puropose
    // should not be used in real life scenarios
    func changePaymentStatus(status: PaymentStatus) async throws -> Invoice {
        let response: Invoice = try await supabase.from(SupabaseTable.invoices.id)
            .update([
                "status": status.rawValue
            ])
            .eq("id", value: id)
            .select(Invoice.supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        return response
    }
    
    // this is for demonstartin puropose
    // should not be used in real life scenarios
    static func changePaymentStatus(paymentType: PaymentType, refrenceId: Int, status: PaymentStatus) async throws -> Invoice {
        let response: Invoice = try await supabase.from(SupabaseTable.invoices.id)
            .update([
                "status": status.rawValue
            ])
            .eq(CodingKeys.paymentType.rawValue, value: paymentType.rawValue)
            .eq(CodingKeys.referenceId.rawValue, value: refrenceId)
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        return response
    }
}
