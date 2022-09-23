//
//  ContentView.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/20/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Log.startTime, ascending: true)],
        animation: .default)
    
    private var logs: FetchedResults<Log>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)],
        animation: .default)
    
    private var exercises: FetchedResults<Exercise>


    var body: some View {
        NavigationView {
            List {
                ForEach(logs, id: \.self) { log in
                    
                    NavigationLink(destination:
                                    LogView(log: log)
                    ) {
                        Text(log.startTime?.description ?? "")
                    }
                }
                .onDelete { index in
                    deleteItems(offsets: index)
                }
                
            }
            .navigationTitle("Select a player")
            .toolbar {
                Button("Add") {
                    addItem()
                }
                Button("Delete ALl") {
                    deleteAll()
                }
            }
        }
        NavigationView {
            List {
                ForEach(exercises, id: \.name) { exercise in
                    Text(exercise.name ?? "")
                }
                .onDelete { index in
                    deleteItems(offsets: index)
                }

            }
            .navigationTitle("Select a player")
            .toolbar {
                Button("Add") {
                    addItem()
                }
                Button("Delete ALl") {
                    deleteAll()
                }
            }
        }
    }
    private func deleteAll() {
        withAnimation {
            var entity = "Log"
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            var entity1 = "Exercise"
            let deleteFetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: entity1)
            let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: deleteFetch1)
            
            deleteRequest.resultType = .resultTypeObjectIDs
            deleteRequest1.resultType = .resultTypeObjectIDs
            
            do {
                let batchDelete = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult
                let batchDelete1 = try viewContext.execute(deleteRequest1) as? NSBatchDeleteResult
                
                guard let deleteResult = batchDelete?.result
                    as? [NSManagedObjectID]
                    else { return }
                
                guard let deleteResult1 = batchDelete1?.result
                    as? [NSManagedObjectID]
                    else { return }
                
                let deletedObjects: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: deleteResult
                ]
                
                let deletedObjects1: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: deleteResult1
                ]
                
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: deletedObjects,
                    into: [viewContext]
                )
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: deletedObjects1,
                    into: [viewContext]
                )
                
                try viewContext.save()
            } catch {
                print ("There was an error")
            }
        }
    }

    private func addItem() {
        withAnimation {
            Log.createWith(name: "Log",
                           startTime: Date(),
                           endtime: nil,
                           bodyWeight: nil,
                           exercises: nil,
                           notes: nil,
                           using: viewContext)
            
            Exercise.createWith(name: "Some Exercise",
                                setNumber: 1,
                                reps: nil,
                                weight: nil,
                                notes: nil,
                                using: viewContext)
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { logs[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
