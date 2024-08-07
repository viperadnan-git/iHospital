import SwiftUI

// Define a Room struct that conforms to Hashable
struct Room: Hashable {
    let number: Int
    let bed: Int
}

struct BedBookingDetailsView: View {
    @State private var selectedDate = Date()
    @State private var selectedWard: String?
    @State private var selectedBedType: String?
    @State private var selectedRoom: Room?
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    let wards = ["General Medical Ward", "Intensive Care Unit (ICU)", "Neonatal Intensive Care Unit (NICU)", "Emergency Ward", "Pediatric Ward", "Maternity Ward"]
    let bedTypes = ["Neonatal Bed/Incubator", "Standard Hospital Bed", "VIP Bed"]
    
    // Define rooms using the Room struct
    let rooms = [
        Room(number: 101, bed: 1), Room(number: 101, bed: 2),
        Room(number: 102, bed: 3), Room(number: 102, bed: 4),
        Room(number: 102, bed: 7), Room(number: 102, bed: 10),
        Room(number: 102, bed: 14), Room(number: 103, bed: 2),
        Room(number: 103, bed: 3), Room(number: 103, bed: 8)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HorizontalCalenderView(selectedDate: $selectedDate)
                    .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Ward Selection
                    HStack {
                        Text("Select Ward")
                        Spacer()
                        Menu {
                            ForEach(wards, id: \.self) { ward in
                                Button(action: {
                                    selectedWard = ward
                                }) {
                                    Text(ward)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedWard ?? "Detail")
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }
                        .accessibilityLabel("Select Ward")
                        .accessibilityHint("Select a ward for the bed booking")
                    }
                    
                    // Bed Type Selection
                    HStack {
                        Text("Select bed type")
                        Spacer()
                        Menu {
                            ForEach(bedTypes, id: \.self) { bedType in
                                Button(action: {
                                    selectedBedType = bedType
                                }) {
                                    Text(bedType)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedBedType ?? "Detail")
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }
                        .accessibilityLabel("Select Bed Type")
                        .accessibilityHint("Select a bed type for the booking")
                    }
                }
                .padding()
                
                Text("Available Beds")
                    .font(.headline)
                    .padding(.trailing, 250)
                
                // Grid of Available Beds
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(rooms, id: \.self) { room in
                        Text("\(room.number)\n\(room.bed)")
                            .multilineTextAlignment(.center)
                            .frame(width: 90, height: 90)
                            .background(selectedRoom == room ? Color.blue.opacity(0.3) : Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .onTapGesture {
                                selectedRoom = room
                            }
                            .accessibilityLabel("Room \(room.number) Bed \(room.bed)")
                            .accessibilityHint("Tap to select this bed")
                    }
                }
                .padding([.leading, .trailing])
                
                Spacer()
                
                // Proceed Button
                Text("Proceed")
                    .frame(maxWidth: .infinity)
                    .padding(.top, -40)
                    .padding(.vertical, 16)
                    .background(Color.clear)
                    .foregroundColor((selectedWard != nil && selectedBedType != nil && selectedRoom != nil) ? Color.blue : Color.gray)
                    .onTapGesture {
                        if selectedWard != nil && selectedBedType != nil && selectedRoom != nil {
                            showAlert = true
                        }
                    }
                    .padding(.bottom, 20)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Payment Successful"),
                            message: Text("Your booking has been completed successfully."),
                            dismissButton: .default(Text("OK"), action: {
                                presentationMode.wrappedValue.dismiss()
                            })
                        )
                    }
                    .accessibilityLabel("Proceed")
                    .accessibilityHint("Tap to complete the booking")
            }
            .navigationTitle("Select a Date")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setInitialDateToJuly2024()
            }
        }
    }
    
    /// Sets the initial date to July 1, 2024
    private func setInitialDateToJuly2024() {
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 7
        dateComponents.day = 1
        if let july2024 = Calendar.current.date(from: dateComponents) {
            selectedDate = july2024
        }
    }
}

#Preview {
    BedBookingDetailsView()
}
