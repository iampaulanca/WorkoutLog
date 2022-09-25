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
    @State var name: String = ""
    @State var reps: String = ""
    @State var setNumber: String = ""
    @State var weight: String = ""
    @State var notes: String = ""
    
    var body: some View {
        
        AddExerciseNavBar(addingExercise: $addingExercise, log: log)
        
        
        List {
            Section {
                TextField("Name", text: $name)
                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
                TextField("Set Number", text: $setNumber)
                    .keyboardType(.numberPad)
                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)
                TextField("Notes", text: $notes)
            }
            
            ForEach(Array(Set(log.exerciseList))) { exercise in
                Text(exercise.name ?? "No name")
            }.onDelete { indexSet in
                // delete exercise
                print("delete exercise")
                deleteItems(offsets: indexSet)
            }

            Button("Add Exercise") {
                
                _ = Exercise.createWith(in: log,
                                        name: !self.name.isEmpty ? self.name : "No Name",
                                        setNumber: Int(self.setNumber) ?? 0,
                                        reps: Int(self.reps) ?? 0,
                                        weight: Double(self.weight) ?? 0.0,
                                        notes: self.notes,
                                        using: viewContext)
                addingExercise.toggle()
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
