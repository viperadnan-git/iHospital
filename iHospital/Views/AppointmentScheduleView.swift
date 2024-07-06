import SwiftUI

struct AppointmentScheduleView: View {
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible = true
    @State private var searchText = ""

    var body: some View {
        NavigationView {
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
                    
                    // Search bar with navigation link
                    NavigationLink(destination: SearchView(searchText: $searchText)) {
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                    
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

struct SearchView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()
            // Add search results or additional search functionalities here
            Spacer()
        }
        .navigationTitle("Search")
    }
}

struct AppointmentScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentScheduleView()
    }
}
