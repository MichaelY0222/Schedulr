//
//  AddTimetableView.swift
//  Schedulr
//
//  Created by Michael Yu on 2025/2/9.
//

import SwiftUI

struct AddTimetableView: View {
    @State private var selectedWeekOption = 0
    let weekOptions = ["Odd Weeks", "Even Weeks"]
    
    @State private var timetable: [[String?]] = Array(repeating: Array(repeating: nil, count: 5), count: 8)
    @State private var availableClasses = ["P&B 102", "Physics 102", "Math 102", "English 102"]
    
    let timeslots = ["08:15", "08:30", "09:40", "10:30", "11:20", "13:10", "14:20", "15:10"]
    let durations = [10.0, 60.0, 40.0, 40.0, 50.0, 60.0, 40.0, 40.0]
    
    // MARK: Main View
    var body: some View {
        NavigationStack {
            VStack {
                headerSection
                ScrollView {
                    HStack(alignment: .top) {
                        timeColumn
                        
                        timetableGrid
                    }
                    .padding()
                    
                    classSelectionBar
                    
                    Spacer()
                }
            }
            .background(Color("Background"))
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack {
            Text("My Timetable")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            Picker("Select a Timeframe", selection: $selectedWeekOption) {
                ForEach(0..<weekOptions.count, id: \.self) { index in
                    Text(weekOptions[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onTapGesture { vibrate(.medium) }
        }
    }
    
    // MARK: - Time Column
    private var timeColumn: some View {
        VStack {
            ForEach(0..<timeslots.count, id: \.self) { i in
                Text(timeslots[i])
                    .frame(width: 60, height: CGFloat(durations[i] * 1.5))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: - Timetable Grid
    private var timetableGrid: some View {
        VStack {
            HStack {
                Text("Mon").frame(maxWidth: .infinity)
                Text("Tue").frame(maxWidth: .infinity)
                Text("Wed").frame(maxWidth: .infinity)
                Text("Thu").frame(maxWidth: .infinity)
                Text("Fri").frame(maxWidth: .infinity)
            }
            .font(.subheadline)
            .padding(.bottom, 5)
            
            VStack {
                ForEach(0..<timetable.count, id: \.self) { row in
                    HStack {
                        ForEach(0..<timetable[row].count, id: \.self) { col in
                            timetableCell(row: row, col: col)
                        }
                    }
                }
            }
            .padding(.all, 8)
            .background(Color("ModuleBackground"))
            .cornerRadius(15)
        }
    }
    
    // MARK: - Timetable Cell
    private func timetableCell(row: Int, col: Int) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: CGFloat(durations[row] * 1.5)) // Adjusted height dynamically
                .cornerRadius(8)
            
            if let className = timetable[row][col] {
                Text(className)
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(6)
            }
        }
        .onDrop(of: ["public.text"], isTargeted: nil) { providers in
            providers.first?.loadObject(ofClass: String.self) { newClass, _ in
                if let newClass = newClass {
                    DispatchQueue.main.async {
                        timetable[row][col] = newClass
                    }
                    vibrate(.medium)
                }
            }
            return true
        }
    }
    
    // MARK: - Class Selection Bar
    private var classSelectionBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(availableClasses, id: \.self) { className in
                    Text(className)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                        .onDrag {
                            NSItemProvider(object: className as NSString)
                        }
                        .onTapGesture { vibrate(.medium) }
                }
                Button(action: { vibrate(.medium) }) {
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddTimetableView()
}
