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
    supabaseURL: URL(string: SUPABASE_URL)!,
    supabaseKey: SUPABASE_KEY
)

enum SupabaseTable: String {
    case users = "users"
    case patients = "patients"
    case doctors = "doctors"
    case departments = "departments"
    
    var id: String {
        self.rawValue
    }
}
