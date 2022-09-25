//
//  AddingExerciseNavBar.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/25/22.
//

import Foundation
import SwiftUI

struct AddExerciseNavBar: View {
    @Binding var addingExercise: Bool
    var log: Log
    var body: some View {
        HStack {
            Button {
                addingExercise.toggle()
            } label: {
                Image(systemName: "x.circle")
            }
            .padding()
            Spacer()
            Text(log.startTime?.description ?? Date().description)
            Spacer()
            Button {
                // create alarm here
            } label: {
                Image(systemName: "alarm")
            }
            .padding()
        }
    }
}
