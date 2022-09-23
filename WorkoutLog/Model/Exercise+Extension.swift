//
//  Exercise+Extension.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/22/22.
//

import Foundation
import CoreData


extension Exercise {
    
    static func createWith(name: String, setNumber: Int, reps: Int?, weight: Double?, notes: String?, using managedObjectContext: NSManagedObjectContext) {
        
        let exercise = Exercise(context: managedObjectContext)
        exercise.name = name
        exercise.setNumber = Int16(setNumber)
        exercise.weight = weight ?? 0.0
        exercise.reps = Int16(reps ?? 0)
        exercise.notes = notes
        
        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            print("\(nserror), \(nserror.userInfo)")
        }

    }
    
    
}
