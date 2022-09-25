//
//  AddLogView.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/24/22.
//

import Foundation
import SwiftUI

struct AddLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var name: String = ""
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    @State var bodyWeight: String = ""
    @State var notes: String = ""
    @Binding var addingLog: Bool
    
    var body: some View {
        Form {
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
        Button("Add Log") {
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
