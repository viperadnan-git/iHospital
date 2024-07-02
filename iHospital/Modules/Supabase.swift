//
//  Supabase.swift
//  iHospital
//
//  Created by Adnan Ahmad on 01/07/24.
//

import Foundation
import UIKit
import Supabase
import Auth

let supabase = SupabaseClient(
    supabaseURL: URL(string: SUPABASE_URL)!,
    supabaseKey: SUPABASE_KEY
)

enum SupabaseTable:String, Codable {
    case users = "users"
}


func handleSupabaseError(error: Error, controller: UIViewController) {
    if let authError = error as? Auth.AuthError {
        UIAlertController.showAlert(title: "Oops!", message: authError.localizedDescription, from: controller)
    } else if let postgrestError = error as? PostgrestError {
        UIAlertController.showAlert(title: "Oops!", message: postgrestError.localizedDescription, from: controller)
    } else {
        print(error)
    }
}
