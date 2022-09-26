//
//  AddExerciseView.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/25/22.
//

import Foundation
import SwiftUI



struct AddExerciseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var log: Log
    @Binding var addingExercise: Bool
    
    @State var reps: String = ""
    
    
    @State var setNumber: String = ""
    @State var weight: String = ""
    
    @State var logName: String
    @State var exerciseName: String = ""
    @State var startTime: Date
    @State var endTime: Date
    @State var bodyWeight: String
    @State var notes: String
    
    
    private enum Field: Int, CaseIterable {
        case name, notes, bodyWeight
    }
    @FocusState private var focusedField: Field?
    var collection = [String: [Exercise]]()
    init(log: Log, addingExercise: Binding<Bool>) {
        self.log = log
        self._addingExercise = addingExercise
        _logName = .init(initialValue: log.name ?? "")
        _startTime = .init(initialValue: log.startTime ?? Date())
        _endTime = .init(initialValue: log.endTime ?? Date())
        _bodyWeight = .init(initialValue: log.bodyWeight?.description ?? "NA")
        _notes = .init(initialValue: log.notes ?? "")
        
        for exercise in log.exerciseList {
            collection[exercise.name ?? "", default: []].append(exercise)
        }
        
    }
    
    var body: some View {
        
        AddExerciseNavBar(addingExercise: $addingExercise, log: log)
        
        NavigationView {
            List {
                
                Section {
                    TextField("Name", text: $logName)
                        .focused($focusedField, equals: .name)
                    
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
                        .focused($focusedField, equals: .bodyWeight)

                    TextField("Notes", text: $notes)
                        .focused($focusedField, equals: .notes)
                        
                }
                
                // Sort by keys first of different workout
                ForEach(collection.keys.sorted(by: <), id: \.self) { key in
                    
                    // get individual workouts
                    Section {
                        ForEach(collection[key]?.sorted(by: {$0.setNumber < $1.setNumber }) ?? []) { val in
                            Text("\(val.name ?? "") Reps: \(val.reps ) weight: \(String(format: "%.1f", val.weight))")
                        }
                    }
                    
                }


                Button("Add Exercise") {
                    AddExerciseView(log: log, addingExercise: $addingExercise)
                    _ = Exercise.createWith(in: log,
                                            name: !self.exerciseName.isEmpty ? self.exerciseName : "Benching",
                                            setNumber: Int(self.setNumber) ?? 1,
                                            reps: Int(self.reps) ?? 10,
                                            weight: Double(self.weight) ?? 135,
                                            notes: self.notes,
                                            using: viewContext)
                    addingExercise.toggle()
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {

                        Button {
                            focusedField = nil
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                        Spacer()
                    }
                }
            }
        }
        
        
        
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { log.exerciseList[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
