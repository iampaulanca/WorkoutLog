//
//  AddLogView.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/24/22.
//

import Foundation
import SwiftUI
import CoreData

struct AddLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var name: String = ""
    @State var startTime: Date = Date()
    @State var endTime: Date = Date() 
    @State var bodyWeight: String = ""
    @State var notes: String = ""
    @Binding var addingLog: Bool
    
    var body: some View {
        ZStack {
            VStack {
                AddLogViewNavbar(addingLog: $addingLog) {
                    Button {
                        addLog(name: name,
                               startTime: startTime,
                               endTime: endTime,
                               bodyWeight: bodyWeight,
                               notes: notes,
                               viewContext: viewContext)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .padding()
                }
                List {
                    Section {
                        AddLogViewLogSection(name: $name,
                                             startTime: $startTime,
                                             endTime: $endTime,
                                             bodyWeight: $bodyWeight,
                                             notes: $notes)
                    }
                    
                    Section {
                            AddLogViewCancelSection(addingLog: $addingLog)
                    }
                }
            }
            
            
        }
        .onDisappear {
            addingLog = false 
        }
        
    }
    
    private func addLog(name:String, startTime: Date, endTime: Date, bodyWeight: String, notes: String, viewContext: NSManagedObjectContext) {

        _ = Log.createWith(name: !name.isEmpty ? self.name : "Log",
                           startTime: Date(),
                           endtime: self.endTime,
                           bodyWeight: NSNumber(value: Double(self.bodyWeight) ?? 0),
                           notes: self.notes,
                           using: viewContext)
        self.addingLog.toggle()
    }
}

//MARK: Sections of the for Add Log view

struct AddLogViewLogSection: View {
    @Binding var name: String
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var bodyWeight: String
    @Binding var notes: String
    
    var body: some View {
        TextField("Name", text: $name)
        DatePicker(
            "Start Time",
            selection: $startTime,
            displayedComponents: [.date, .hourAndMinute]
        )
        DatePicker(
            "End Time",
            selection: $endTime,
            displayedComponents: [.date, .hourAndMinute]
        )
        TextField("BodyWeight", text: $bodyWeight)
            .keyboardType(.decimalPad)
        TextField("Notes", text: $notes)
        
    }
    
}

struct AddLogViewCancelSection: View {
    @Binding var addingLog: Bool
    var body: some View {
        HStack {
            Spacer()
            Button("Cancel") {
                addingLog.toggle()
            }
            .foregroundColor(Color.red)
            Spacer()
        }
        
    }
}

struct AddLogViewNavbar<Content: View>: View {
    @Binding var addingLog: Bool
    let content: Content
    init(addingLog: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._addingLog = addingLog
        self.content = content()
    }
    var body: some View {
        HStack {
            Text("New Workout Log")
                .font(.title)
                .bold()
                .padding()
            Spacer()
            content
        }
    }
}
