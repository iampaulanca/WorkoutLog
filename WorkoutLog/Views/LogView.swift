//
//  LogItem.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/20/22.
//

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
        
        VStack {
            Text(log.name ?? "")
            Text(log.startTime?.description ?? "")
            Text(log.endTime?.description ?? "")
            
            ForEach(log.exerciseList, id: \.name) { exercise in
                Text(exercise.name ?? "Default exercise name")
            }
            
        }
        
        
        Form {
            TextField("Name", text: $name)
            TextField("Reps", text: $reps)
                .keyboardType(.numberPad)
            TextField("Set Number", text: $setNumber)
                .keyboardType(.numberPad)
            TextField("Weight", text: $weight)
                .keyboardType(.decimalPad)
            TextField("Notes", text: $notes)
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


struct LogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var height: CGFloat = 50
    @State var addingExercise = false
    @ObservedObject var log: Log
    
    var body: some View {
        HStack{
            VStack{
                Text("Tue")
                Text("20")
                    .bold()
                    .font(.title)
            }
            .padding()
            VStack(alignment: .leading) {
                Text(log.name ?? "Log")
                    .bold()
                ForEach(log.exerciseList, id: \.self) { exercise in
                    Text(exercise.reps != 0 ?
                         "\(exercise.reps)x \(exercise.name ?? "")" :
                            "1x\(exercise.name ?? "")")
                }
                Spacer()
            }
            .overlay {
                GeometryReader { geo in
                    Color.clear.preference(key: HeightPreferenceKey.self, value: geo.size.height)
                }
            }
            
            Spacer()
            VStack {
                Spacer()
                Text("23 min")
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            addingExercise.toggle()
        }
        .onPreferenceChange(HeightPreferenceKey.self) { value in
            self.height = value
        }
        .frame( height: self.height)
        .padding()
        .sheet(isPresented: $addingExercise) {
            AddExerciseView(log: log, addingExercise: $addingExercise)
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 20.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}

struct LogItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newLog = Log(context: context)
        newLog.name = "LogView"
        return LogView(log: newLog).environment(\.managedObjectContext, context)
    }
}

