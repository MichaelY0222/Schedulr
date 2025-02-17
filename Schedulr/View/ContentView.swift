//
//  ContentView.swift
//  Schedulr
//
//  Created by Michael Yu on 2025/2/8.
//

import SwiftUI

struct ContentView: View {
    @State private var addedPersonalTimetable = false
    @State private var navigateToAdminView = false
    @State private var navigateToScanner = false
    @State private var navigateToAddPersonalTimetable = false
    @State private var scannedCodeData: String?
    @State private var lastLargeTitleTapTime: Date?
    @State private var largeTitleTapCount: Int = 0
    private let maxLargeTitleTapInterval: TimeInterval = 0.5
    
    var body: some View {
        NavigationStack {
            VStack {
                // Title Section
                Text("Schedulr")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .onTapGesture { handleLargeTitleTap() }
                Text(Date(), format: .dateTime.weekday(.wide).month(.wide).day().year())
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                // Check if timetable is added
                if addedPersonalTimetable {
                    VStack {
                        Text("My Timetable")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("ModuleBackground"))
                    .cornerRadius(10)
                    .padding()
                    Text(scannedCodeData ?? "")
                        .foregroundColor(.init("RedText"))
                } else {
                    VStack (spacing: 3) {
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .padding(.bottom)
                        Text("Start Scheduling")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("ButtonText"))
                        Text("Collect and share timetables.")
                            .font(.subheadline)
                            .foregroundColor(Color("ModuleText"))
                        Text("Tap the plus button to get started.")
                            .font(.subheadline)
                            .foregroundColor(Color("ModuleText"))
                        Spacer()
                    }
                }
                Spacer()
            }
            .background(Color("Background"))

            .navigationDestination(isPresented: $navigateToAdminView) { AdminView() }
            .navigationDestination(isPresented: $navigateToAddPersonalTimetable) { AddTimetableView() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: openScanner) {
                        Image(systemName: "qrcode.viewfinder")
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("ButtonText"))
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("ModuleBackground")))
                    }
                }
            }
            .sheet(isPresented: $navigateToScanner) {
                ScannerView { scannedCode in
                    if let code = scannedCode {
                        scannedCodeData = code
                    }
                }
            }

            if (!addedPersonalTimetable){
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { addPersonalTimetable()}) {
                            ZStack {
                                Circle()
                                    .fill(Color("ButtonBackground"))
                                    .frame(width: 70, height: 70)
                                Text("+")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color("ButtonText"))
                            }
                            .shadow(radius: 8)
                        }
                        Spacer()
                    }
                }
                .background(Color("Background"))
            }
        }
        .onAppear {
            checkPersonalTimetableStatus()
        }
    }
       
    func openScanner() {
        vibrate(.medium)
        navigateToScanner = true
    }
    
    func addPersonalTimetable() {
        vibrate(.medium)
        navigateToAddPersonalTimetable = true
    }
    
    func handleLargeTitleTap() {
        let currentTime = Date()
        
        if let lastTap = lastLargeTitleTapTime, currentTime.timeIntervalSince(lastTap) < maxLargeTitleTapInterval {
            largeTitleTapCount += 1
        } else { largeTitleTapCount = 1 }
        lastLargeTitleTapTime = currentTime
        
        if largeTitleTapCount == 5 {
            largeTitleTapCount = 0
            navigateToAdminView = true
            vibrate(.medium)
        }
    }
    
    func checkPersonalTimetableStatus() {
        if let personalTimetableStatus = UserDefaults.standard.value(forKey: "personalTimetableKey") as? Bool {
            addedPersonalTimetable = personalTimetableStatus
        }
    }
}

#Preview {
    ContentView()
}
