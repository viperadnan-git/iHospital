//
//  FSCalenderView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct FSCalenderView: View {
    @Binding var selectedDate: Date
    @State private var weeks: [[Date]] = []
    @State private var currentMonth: String = ""
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(currentMonth)
                .font(.title)
                .padding()
            
            TabView {
                ForEach(weeks.indices, id: \.self) { weekIndex in
                    let week = weeks[weekIndex]
                    HStack {
                        ForEach(week, id: \.self) { date in
                            VStack {
                                Text(date, formatter: dateFormatter)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(date, formatter: dayFormatter)
                                    .font(.title2)
                                    .fontWeight(selectedDate == date ? .bold : .regular)
                                    .padding(8)
                                    .background(selectedDate == date ? Color.blue : Color.clear)
                                    .foregroundColor(selectedDate == date ? .white : .black)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        selectedDate = date
                                        updateCurrentMonth(for: date)
                                    }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .onAppear {
                        if weekIndex == weeks.count - 1 {
                            addNextWeek()
                        } else if weekIndex == 0 {
                            addPreviousWeek()
                        }
                        updateCurrentMonth(for: week.first!)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .padding()
        }
        .onAppear(perform: setupInitialWeeks)
    }
    
    private func setupInitialWeeks() {
        weeks = []
        addPreviousWeek()
        addCurrentWeek()
        addNextWeek()
        updateCurrentMonth(for: selectedDate)
    }
    
    private func addPreviousWeek() {
        guard let firstDate = weeks.first?.first else { return }
        guard let previousWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: firstDate) else { return }
        let previousWeek = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: previousWeekStart)
        }
        weeks.insert(previousWeek, at: 0)
    }
    
    private func addCurrentWeek() {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else { return }
        
        print(weekInterval)

        let currentWeek = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekInterval.start)
        }
        print(currentWeek)
        weeks.append(currentWeek)
    }
    
    private func addNextWeek() {
        guard let lastDate = weeks.last?.last else { return }
        guard let nextWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: lastDate) else { return }
        let nextWeek = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: nextWeekStart)
        }
        weeks.append(nextWeek)
    }
    
    private func updateCurrentMonth(for date: Date) {
        currentMonth = monthFormatter.string(from: date)
    }
}



#Preview {
    FSCalenderView(selectedDate: .constant(Date()))
        .previewLayout(.sizeThatFits)
}
