//
//  ContentView.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/20/22.
//

import SwiftUI
import CoreData



struct ContentView: View {
    var body: some View {
        TabView {
            LogListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Log")
                }
            
            Text("Routines")
                .tabItem {
                    Image(systemName: "dumbbell")
                    Text("Routines")
                }
            
            Text("Statistics")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
