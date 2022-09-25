//
//  AddLogView.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/24/22.
//

import Foundation
import SwiftUI

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

struct AddLogViewAddLogSection: View {
    @Environment(\.managedObjectContext) private var viewContext
    var name: String
    var startTime: Date
    var endTime: Date
    var bodyWeight: String
    var notes: String
    @Binding var addingLog: Bool
    var body: some View {
        Button("Add") {
            _ = Log.createWith(name: !self.name.isEmpty ? self.name : "Log",
                                     startTime: Date(),
                                     endtime: self.endTime,
                                     bodyWeight: NSNumber(value: Double(self.bodyWeight) ?? 0),
                                     notes: self.notes,
                                     using: viewContext)
            addingLog.toggle()
        }
    }
}

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
            List {
                Section {
                    AddLogViewLogSection(name: $name,
                                         startTime: $startTime,
                                         endTime: $endTime,
                                         bodyWeight: $bodyWeight,
                                         notes: $notes)
                }
                
                Section {
                    HStack {
                        Spacer()
                        AddLogViewAddLogSection(name: name,
                                                     startTime: startTime,
                                                     endTime: endTime,
                                                     bodyWeight: bodyWeight,
                                                     notes: notes,
                                                     addingLog: $addingLog)
                        Spacer()
                    }
                    
                }
                
            }
            
            
        }
        .onDisappear {
            addingLog = false 
        }
        
    }
}
