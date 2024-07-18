//
//  Supabase.swift
//  iHospital
//
//  Created by Adnan Ahmad on 03/07/24.
//

import Foundation
import SwiftUI
import Supabase
import Auth

let supabase = SupabaseClient(
    supabaseURL: URL(string: Constants.supabaseURL)!,
    supabaseKey: Constants.supabaseKey
)

/// Enum representing different tables in the Supabase database
enum SupabaseTable: String {
    case users
    case doctors
    case departments
    case patients
    case appointments
    case medicalRecords = "medical_records"
    case labTests = "lab_tests"
    case labTestTypes = "lab_test_types"
    case invoices
    case bedBookings = "bed_bookings"
    
    /// Returns the raw value of the table name
    var id: String {
        self.rawValue
    }
}

/// Enum representing different storage buckets in Supabase
enum SupabaseBucket: String {
    case avatars
    case medicalRecords = "medical_records"
    case labReports = "lab_reports"
    
    /// Returns the raw value of the bucket name
    var id: String {
        self.rawValue
    }
}

/// Enum representing various errors that can occur while interacting with Supabase
enum SupabaseError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidUser
    case invalidRole
    case invalidDoctor
    case invalidDepartment
    case unauthorized
}
