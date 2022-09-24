//
//  LogItem.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/20/22.
//

import SwiftUI

struct LogView: View {
    @State private var height: CGFloat = 20.0
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var log: Log
    
    var body: some View {
        
        HStack{
            Button("Add Exercise") {
                Exercise.createWith(in: log,
                                    name: "Some New Exercise",
                                    setNumber: 1,
                                    reps: nil,
                                    weight: nil,
                                    notes: nil,
                                    using: viewContext)
            }
            VStack{
                Text("Tue")
                Text("20")
                    .bold()
                    .font(.title)
            }
            .padding()
                VStack(alignment: .leading) {
//                    Text("Evening workout")
//                        .bold()
//                        .font(.title)
                    ForEach(log.exerciseList, id: \.self) { exercise in
                        
                        Text(exercise.name ?? "")
                        
                    }
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
        .onPreferenceChange(HeightPreferenceKey.self) { value in
            self.height = value
        }
        .frame(height: self.height)
        
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
