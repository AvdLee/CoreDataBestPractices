//
//  Insertions.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

extension Article {
    static func insertSamplesOneByOne(_ numberOfSamples: Int) throws {
        let taskContext = PersistentContainer.shared.backgroundContext()
        taskContext.perform {
            do {
                let category = Category(context: taskContext)
                category.name = "SwiftUI"

                (0..<numberOfSamples).forEach { index in
                    let article = Article(context: taskContext)
                    article.name = String(format: "Generated %05d", index)
                    article.category = category
                }

                try taskContext.save()
                taskContext.reset()
                print("### \(#function): One by one inserted \(numberOfSamples) posts")
            } catch {
                print("### \(#function): Failed to insert articles in batch: \(error)")
            }
        }
    }

    /*
     Pro:
         - Lower memory as it operates at the SQL level and doesn’t load objects into memory
     Cons:
        - No validation rules applied
        - Relationships can't be set
        - Dictionary initialisation or JSON dictionary in which keys should exactly match entity models
    */
    static func insertSamplesInBatch(_ numberOfSamples: Int) throws {
        let taskContext = PersistentContainer.shared.backgroundContext()
        taskContext.perform {
            do {
                let creationDate = Date()
                let objects = (0..<numberOfSamples).map { index -> [String: Any] in
                    return [
                        "name": String(format: "Generated %05d", index),
                        "creationDate": creationDate,
                        "lastModifiedDate": creationDate
                    ]
                }
                try insertObjectsInBatch(objects, into: taskContext)
                try taskContext.save()
                taskContext.reset()
                print("### \(#function): Batch inserted \(numberOfSamples) posts")
            } catch {
                print("### \(#function): Failed to insert articles in batch: \(error)")
            }
        }
    }

    static func insertObjectsInBatch(_ objects: [[String: Any]], into context: NSManagedObjectContext) throws {
        let insertRequest = NSBatchInsertRequest(entity: entity(), objects: objects)
        try context.execute(insertRequest)
    }
}
