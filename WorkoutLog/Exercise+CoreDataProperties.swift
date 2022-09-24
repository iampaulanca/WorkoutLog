//
//  Exercise+CoreDataProperties.swift
//  WorkoutLog
//
//  Created by Paul Ancajima on 9/23/22.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var reps: Int16
    @NSManaged public var setNumber: Int16
    @NSManaged public var weight: Double
    @NSManaged public var log: Log
    
    static func createWith(in log: Log, name: String, setNumber: Int, reps: Int?, weight: Double?, notes: String?, using managedObjectContext: NSManagedObjectContext)  -> Exercise {
        
        let exercise = Exercise(context: managedObjectContext)
        exercise.log = log
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
        
        return exercise

    }

}

extension Exercise : Identifiable {

}
