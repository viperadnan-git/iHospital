//
//  AppointmentView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

import SwiftUI

struct AppointmentScheduleView: View {
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Button to toggle date picker visibility
                Button(action: {
                    withAnimation {
                        isDatePickerVisible.toggle()
                    }
                }) {
                    Text(isDatePickerVisible ? "Hide Calendar" : "Show Calendar")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, geometry.safeAreaInsets.top + 10)
                .padding(.horizontal)
                
                if isDatePickerVisible {
                    // Standard Date Picker with restricted range
                    DatePicker(
                        "Select a date",
                        selection: $selectedDate,
                        in: Date()...Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                }
                
                Text(formattedDate(for: selectedDate))
                    .font(.headline)
                    .padding(.top, 8)
                
                // Search bar
                HStack {
                    TextField("Doctors / Departments", text: .constant(""))
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Button(action: {
                        // Voice search action
                    }) {
                        Image(systemName: "mic.fill")
                            .padding()
                    }
                }
                .padding()
                
                // Previously visited doctors
                VStack(alignment: .leading) {
                    Text("Previously visited")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<4) { index in
                                VStack {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    Text("Dr. Suresh")
                                        .font(.subheadline)
                                    
                                    Text(specialty(for: index))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, index == 0 ? 16 : 8)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
        .padding(.horizontal)
    }
    
    func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    func specialty(for index: Int) -> String {
        let specialties = ["Surgeon", "Orthopedic", "Neurologist", "Orthopedic"]
        return specialties[index]
    }
}

struct AppointmentScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentScheduleView()
    }
}


//
//  AppointmentView.swift
//  iHospital
//
//  Created by Shoaib Akhtar on 04/07/24.
//

//import SwiftUI
//
//struct AppointmentView: View {
//    @State private var selectedDate = Date()
//    @State private var isDatePickerVisible = true
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                Spacer().frame(height: geometry.safeAreaInsets.top + 10)
//                
//                // List with a single cell to toggle date picker visibility
//                List {
//                    Section {
//                        ToggleCell(isDatePickerVisible: $isDatePickerVisible)
//                    }
//                }
//                .listStyle(InsetGroupedListStyle())
//                .frame(height: 60) // Adjust height to match cell height
//                
//                if isDatePickerVisible {
//                    // Standard Date Picker with restricted range
//                    DatePicker(
//                        "Select a date",
//                        selection: $selectedDate,
//                        in: Date()...Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
//                        displayedComponents: .date
//                    )
//                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .padding()
//                }
//                
//                Text(formattedDate(for: selectedDate))
//                    .font(.headline)
//                    .padding(.top, 8)
//                
//                // Search bar
//                HStack {
//                    TextField("Doctors / Departments", text: .constant(""))
//                        .padding(8)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                    
//                    Button(action: {
//                        // Voice search action
//                    }) {
//                        Image(systemName: "mic.fill")
//                            .padding()
//                    }
//                }
//                .padding()
//                
//                // Previously visited doctors
//                VStack(alignment: .leading) {
//                    Text("Previously visited")
//                        .font(.headline)
//                        .padding(.leading)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack {
//                            ForEach(0..<4) { index in
//                                VStack {
//                                    Image(systemName: "person.fill")
//                                        .resizable()
//                                        .frame(width: 80, height: 80)
//                                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                                    
//                                    Text("Dr. Suresh")
//                                        .font(.subheadline)
//                                    
//                                    Text(specialty(for: index))
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                .padding(.leading, index == 0 ? 16 : 8)
//                            }
//                        }
//                    }
//                    .padding(.vertical)
//                }
//                
//                Spacer()
//            }
//            .edgesIgnoringSafeArea(.top)
//        }
//        .padding(.horizontal)
//    }
//    
//    func formattedDate(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .full
//        return formatter.string(from: date)
//    }
//    
//    func specialty(for index: Int) -> String {
//        let specialties = ["Surgeon", "Orthopedic", "Neurologist", "Orthopedic"]
//        return specialties[index]
//    }
//}
//
//struct ToggleCell: View {
//    @Binding var isDatePickerVisible: Bool
//    
//    var body: some View {
//        HStack {
//            Text("Calendar")
//            Spacer()
//            Button(action: {
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    isDatePickerVisible.toggle()
//                }
//            }) {
//                Text(isDatePickerVisible ? "Hide" : "Show")
//                    .foregroundColor(.blue)
//            }
//        }
//        .padding()
//    }
//}
//
//struct AppointmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentView()
//    }
//}
