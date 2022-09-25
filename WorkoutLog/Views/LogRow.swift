//
//  LogRow.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/24/22.
//

import Foundation
import SwiftUI

struct LogRow: View {
    var log: Log
    
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(12)
            LogView(log: log)
                .padding([.vertical])
        }
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct LogRow_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let log = Log.createWith(name: "SomeLog", endtime: nil, notes: nil, using: viewContext)
        LogRow(log: log)
    }
}
