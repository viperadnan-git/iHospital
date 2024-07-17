//
//  SlotListView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 17/07/24.
//

import SwiftUI

struct SlotListView: View {
    var slots: [(Date, Bool)]
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
                            }
                        }
                    }) {
                        Text(slot, style: .time)
                            .padding(8)
                            .background(selection == slot ? Color.accentColor : isBooked ? Color.gray.opacity(0.5) : Color.accentColor.opacity(0.2))
                            .foregroundColor(selection == slot ? Color.white : isBooked ? Color.gray : Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(isBooked)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SlotListView(slots: [(Date(), false)], selection: .constant(nil))
}
