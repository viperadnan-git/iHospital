import SwiftUI

struct RescheduleAppointment: View {
    var appointment: Appointment = Appointment.sample
    @State private var selectedDate = Date()
    @State private var availableSlots: [Date] = []
    @State private var isLoading = false
    @StateObject private var errorAlertMessage = ErrorAlertMessage()
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("Select Date")
                        .padding(.leading)
                        .foregroundColor(.black)
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                        .padding(.top , 3)
                }
                Divider()
                
                Text("Available Slots")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(50), spacing: 5), count: 4), spacing: 8) {
                        ForEach(availableSlots, id: \.self) { slot in
                            Button(action: {
                                print("Slot selected: \(slot)")
                            }) {
                                Text(slot, style: .time)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationTitle("Reschedule Appointment")
        
        //Confirm button
            .toolbar {
                NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                    Button("Confirm", action: {
                       
                    })
                }
            }
            .onAppear {
                fetchAvailableSlots(for: selectedDate)
            }
        }
        
        private func fetchAvailableSlots(for date: Date) {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                availableSlots = generateDummySlots()
                isLoading = false
            }
        }
        
        private func generateDummySlots() -> [Date] {
            var slots: [Date] = []
            let calendar = Calendar.current
            let now = Date()
            
            for i in 0..<16 {
                let slot = calendar.date(byAdding: .minute, value: 30 * i, to: now)!
                slots.append(slot)
            }
            
            return slots
        }
    }
struct RescheduleAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        RescheduleAppointment()
    }
}
