//
//  HorizontalCalenderView.swift
//  iHospital
//
//  Created by Adnan Ahmad on 05/07/24.
//

import SwiftUI

struct HorizontalCalenderView: View {
    @Binding var selectedDate: Date
    @State private var weeks: [[Date]] = []
    @State private var currentMonth: String = ""
    
    private let calendar = Calendar(identifier: .gregorian)
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
    
    private let today = Date()
    
    var body: some View {
        VStack {
            Text(currentMonth)
                .font(.caption)
                .padding(.top, 8)
            
            TabView {
                ForEach(weeks.indices, id: \.self) { weekIndex in
                    let week = weeks[weekIndex]
                    HStack(spacing: 4) {
                        ForEach(week, id: \.self) { date in
                            let disabled = date < calendar.startOfDay(for: today)
                            VStack {
                                Text(date, formatter: dateFormatter)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Button(action: {
                                    selectedDate = date
                                    updateCurrentMonth(for: date)
                                }) {
                                    Text(date, formatter: dayFormatter)
                                        .font(.title2)
                                        .padding(8)
                                        .background(
                                            selectedDate == date ? .accent :
                                                date == today.startOfDay ? .accent.opacity(0.2) : Color.clear
                                        )
                                        .foregroundColor(selectedDate == date ? .white : date == today.startOfDay ? .accentColor : disabled ? .gray : .primary)
                                        .clipShape(Circle())
                                }
                                .disabled(disabled)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 8)
                    .frame(maxHeight: 58)  // Adjust height here
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
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 100) // Adjust the frame height for TabView
        }
        .onAppear(perform: setupInitialWeeks)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func setupInitialWeeks() {
        weeks = []
        addCurrentWeek()
        addNextWeek()
        addPreviousWeek()
        updateCurrentMonth(for: selectedDate)
    }
    
    private func addPreviousWeek() {
        guard let firstDate = weeks.first?.first else { return }
        guard let previousWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: firstDate),
              previousWeekStart >= calendar.startOfDay(for: today) else { return }
        let previousWeek = generateWeek(for: previousWeekStart)
        weeks.insert(previousWeek, at: 0)
    }
    
    private func addCurrentWeek() {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else { return }
        let startOfWeek = max(weekInterval.start, calendar.startOfDay(for: today))
        let currentWeek = generateWeek(for: startOfWeek)
        weeks.append(currentWeek)
    }
    
    private func addNextWeek() {
        guard let lastDate = weeks.last?.last else { return }
        guard let nextWeekStart = calendar.date(byAdding: .day, value: 1, to: lastDate) else { return }
        let nextWeek = generateWeek(for: nextWeekStart)
        weeks.append(nextWeek)
    }
    
    private func generateWeek(for startDate: Date) -> [Date] {
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate))!
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
    
    private func updateCurrentMonth(for date: Date) {
        currentMonth = monthFormatter.string(from: date)
    }
}

#Preview {
    HorizontalCalenderView(selectedDate: .constant(Date()))
        .previewLayout(.sizeThatFits)
        .border(.black)
}
