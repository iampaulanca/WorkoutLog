//
//  Log+CoreDataProperties.swift
//
//
//  Created by Paul Ancajima on 9/22/22.
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var bodyWeight: NSNumber?
    @NSManaged public var endTime: Date?
    @NSManaged public var exerciseList: [Exercise]
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var startTime: Date?
    
    static func createWith(name: String,
                           startTime: Date? = Date(),
                           endtime: Date?,
                           bodyWeight: NSNumber? = nil,
                           notes: String?,
                           using managedObjectContext: NSManagedObjectContext) ->  Log {
        let log = Log(context: managedObjectContext)
        log.name = name
        log.startTime = startTime
        log.endTime = endtime
        log.bodyWeight = bodyWeight
        log.notes = notes
        
        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return log 
    }

}

extension Log : Identifiable {

}
