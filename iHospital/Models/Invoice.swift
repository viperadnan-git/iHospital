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
    
    /// Fetches the referenced object based on the payment type
    /// - Returns: The referenced object (Appointment, LabTest, or BedBooking)
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
    
    /// Fetches an appointment by reference ID
    /// - Parameter referenceId: The ID of the appointment
    /// - Returns: The fetched appointment
    private func fetchAppointment(referenceId: Int) async throws -> Appointment {
        let response: Appointment = try await supabase.from(SupabaseTable.appointments.id)
            .select(Appointment.supabaseSelectQuery)
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Fetches a lab test by reference ID
    /// - Parameter referenceId: The ID of the lab test
    /// - Returns: The fetched lab test
    private func fetchLabTest(referenceId: Int) async throws -> LabTest {
        let response: LabTest = try await supabase.from(SupabaseTable.labTests.id)
            .select(LabTest.supabaseSelectQuery)
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Fetches a bed booking by reference ID
    /// - Parameter referenceId: The ID of the bed booking
    /// - Returns: The fetched bed booking
    private func fetchBedBooking(referenceId: Int) async throws -> BedBooking {
        let response: BedBooking = try await supabase.from(SupabaseTable.bedBookings.id)
            .select()
            .eq("id", value: referenceId)
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Changes the payment status of the invoice
    /// - Parameter status: The new payment status
    /// - Returns: The updated invoice
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
    
    /// Changes the payment status of the invoice based on payment type and reference ID
    /// - Parameters:
    ///   - paymentType: The type of payment
    ///   - referenceId: The ID of the reference
    ///   - status: The new payment status
    /// - Returns: The updated invoice
    static func changePaymentStatus(paymentType: PaymentType, referenceId: Int, status: PaymentStatus) async throws -> Invoice {
        let response: Invoice = try await supabase.from(SupabaseTable.invoices.id)
            .update([
                "status": status.rawValue
            ])
            .eq(CodingKeys.paymentType.rawValue, value: paymentType.rawValue)
            .eq(CodingKeys.referenceId.rawValue, value: referenceId)
            .select(supabaseSelectQuery)
            .single()
            .execute()
            .value
        
        return response
    }
}
