//
//  BookingViewModel.swift
//  iHospital
//
//  Created by Adnan Ahmad on 07/07/24.
//

import SwiftUI
import Combine

class BookingViewModel: ObservableObject {
    @Published var doctor: Doctor?
    @Published var selectedSlot: Date?
    @Published var forDate: Date = Date()
}
