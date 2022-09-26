//
//  LogListView.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/25/22.
//

import SwiftUI
import CoreData

struct LogListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Log.startTime, ascending: true)],
        animation: .default)
    
    private var logs: FetchedResults<Log>
    
    @State var addingLog: Bool = false
    
    var body: some View {
        
            NavigationView {
                ZStack {
                    VStack {
                        List {
                            ForEach(logs, id: \.self) { log in
                                LogRow(log: log)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .font(.body)
                            }
                            .onDelete { indexSet in
                                deleteItems(offsets: indexSet)
                            }
                        }
                        .toolbar {
                            // Work around: Apple bug toolbar button not working after modal presented
                            Text(addingLog ? " " : "").hidden()
                            Button {
                                addingLog.toggle()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .fullScreenCover(isPresented: $addingLog) {
                                AddLogView(addingLog: $addingLog)
                            }
                            
                            Button {
                                deleteAll()
                            } label: {
                                Image(systemName: "minus")
                            }
                        }
                        .navigationTitle("Log")
                        
                        
                    }
                    
                    
                }
            
        }
        
        
    }
    
    private func deleteAll() {
        
        withAnimation {
            let entity = "Exercise"
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            deleteRequest.resultType = .resultTypeObjectIDs
            do {
                let batchDelete = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult
                guard let deleteResult = batchDelete?.result
                        as? [NSManagedObjectID]
                else { return }
                
                
                let deletedObjects: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: deleteResult
                ]
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: deletedObjects,
                    into: [viewContext]
                )
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                print("\(nserror), \(nserror.userInfo)")
            }
        }
        withAnimation {
            let entity = "Log"
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            deleteRequest.resultType = .resultTypeObjectIDs
            do {
                let batchDelete = try viewContext.execute(deleteRequest) as? NSBatchDeleteResult
                guard let deleteResult = batchDelete?.result
                        as? [NSManagedObjectID]
                else { return }
                
                
                let deletedObjects: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: deleteResult
                ]
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: deletedObjects,
                    into: [viewContext]
                )
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                print("\(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            _ = Log.createWith(name: "Log",
                                     startTime: Date(),
                                     endtime: nil,
                                     bodyWeight: nil,
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
