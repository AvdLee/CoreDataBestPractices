//
//  Deletions.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func deleteAllOneByOne() throws {
        let taskContext = PersistentContainer.shared.newBackgroundContext()
        taskContext.perform {
            do {
                let fetchRequest = self.fetchRequest()
                let objects = try taskContext.fetch(fetchRequest) as! [NSManagedObject]
                objects.forEach { object in
                    taskContext.delete(object)
                }
                try taskContext.save()
                taskContext.reset()
                print("### \(#function): One by one deleted post count: \(objects.count)")
            } catch {
                print("### \(#function): Failed to delete existing records one by one: \(error)")
            }
        }
    }

    /*
     Pro:
     - Lower memory as it operates at the SQL level and doesn’t load objects into memory
     Cons:
     - No validation rules applied
     - In-memory objects are not updated without a merge notification or Persistent History Tracking enabled
     */
    static func deleteAllInBatch() throws {
        let taskContext = PersistentContainer.shared.newBackgroundContext()
        taskContext.perform {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: self.fetchRequest())
            batchDeleteRequest.resultType = .resultTypeCount
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                try taskContext.save()
                taskContext.reset()
                print("### \(#function): Batch deleted post count: \(String(describing: batchDeleteResult?.result))")
            } catch {
                print("### \(#function): Failed to batch delete existing records: \(error)")
            }
        }
    }
}
