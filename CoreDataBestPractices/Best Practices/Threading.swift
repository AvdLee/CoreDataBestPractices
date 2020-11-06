//
//  Threading.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import Foundation
import CoreData

/*
 The important part of threading in Core Data is passing along managed objects across different contexts.
 The basic rule is to always use managed object IDs when passing along objects.
 */

extension PersistentContainer {

    /// Wrong: don't pass the objects.
    /// With `-com.apple.CoreData.ConcurrencyDebug 1` launch argument enabled this is catched early on.
    func deleteObjects(_ objects: [NSManagedObject]) {
        let taskContext = newBackgroundContext()
        taskContext.perform {
            objects.forEach { object in
                /// This will crash:
                /// 'An NSManagedObjectContext cannot delete objects in other contexts.'
                taskContext.delete(object)
            }

            try! taskContext.save()
            taskContext.reset()
        }
    }

    /// Good: pass in object IDs.
    func deleteObjectsWithIDs(_ objectIDs: [NSManagedObjectID]) {
        let taskContext = newBackgroundContext()
        taskContext.perform {
            objectIDs.compactMap { objectID -> NSManagedObject? in
                try? taskContext.existingObject(with: objectID)
            }.forEach { object in
                taskContext.delete(object)
            }

            try! taskContext.save()
            taskContext.reset()
        }
    }

    func synchronousWork() {
        let mainThread = viewContext
        mainThread.perform {
            // Blocks the UI
            print("View context perform on \(Thread.current)")
        }
        mainThread.performAndWait {
            // Blocks the UI.
            print("View context perform and wait on \(Thread.current)")
        }
        let backgroundThread = newBackgroundContext()
        backgroundThread.perform {
            // Does not block the UI.
            print("Background context perform on \(Thread.current)")
        }
        backgroundThread.performAndWait {
            // Does block the thread it's being called on.
            // In this case, the main thread.
            print("Background context perform and wait on \(Thread.current)")
        }
    }
}
