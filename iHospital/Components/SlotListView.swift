//
//  SlotListView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct SlotListView: View {
    var slots: [(Date, Bool)]
    @Binding var doctor: Doctor?
    @Binding var selection: Date?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: Array(repeating: GridItem(.fixed(40), spacing: 10), count: 4), spacing: 10) {
                ForEach(slots, id: \.0) { slot, isBooked in
                    Button(action: {
                        if !isBooked {
                            if selection == slot {
                                selection = nil
                            } else {
                                selection = slot
                                doctor = doctor
                            }
                        }
                    }) {
                        Text(slot, style: .time)
                            .padding(8)
                            .background(selection == slot ? Color.accentColor : isBooked ? Color.gray.opacity(0.5) : Color.accentColor.opacity(0.2))
                            .foregroundColor(selection == slot ? Color.white : isBooked ? Color.gray : Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibilityLabel("Slot at \(slot.formatted(.dateTime.hour().minute())), \(isBooked ? "Booked" : "Available")")
                            .accessibilityHint(selection == slot ? "Selected slot" : "Tap to select this slot")
                    }
                    .disabled(isBooked)
                }
            }
            .padding(.horizontal)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Slot list view")
    }
}

#Preview {
    SlotListView(slots: [(Date(), false)], doctor: .constant(.sample), selection: .constant(nil))
}
