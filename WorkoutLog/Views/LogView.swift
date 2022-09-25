//
//  LogItem.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/20/22.
//

import SwiftUI

struct LogView: View {
    @State private var height: CGFloat = 50
    @Environment(\.managedObjectContext) private var viewContext
    
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
                Text("Evening Workout")
                    .bold()
                ForEach(log.exerciseList, id: \.self) { exercise in
                    Text(exercise.reps != 0 ?
                         "\(exercise.reps)x \(exercise.name ?? "")" :
                            "1x\(exercise.name ?? "")")
//                        .font(.body)
//                        .lineLimit(1)
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
            Exercise.createWith(in: log,
                                name: "Squat",
                                setNumber: 1,
                                reps: 10,
                                weight: nil,
                                notes: nil,
                                using: viewContext)
            
        }
        .onPreferenceChange(HeightPreferenceKey.self) { value in
            self.height = value
        }
        .frame( height: self.height)
        .padding()
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

