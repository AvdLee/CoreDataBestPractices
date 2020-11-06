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
        let taskContext = PersistentContainer.shared.newBackgroundContext()
        taskContext.perform {
            do {
                let category = Category.insertSample(into: taskContext)

                (0..<numberOfSamples).forEach { index in
                    let article = Article(context: taskContext)
                    article.name = String(format: "Generated %05d", index)
                    article.category = category
                    article.source = .generated
                    article.views = Int.random(in: 0..<1000)
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
        let taskContext = PersistentContainer.shared.newBackgroundContext()
        taskContext.perform {
            do {
                let creationDate = Date()

                var index = 0

                let insertRequest = NSBatchInsertRequest(entity: entity(), managedObjectHandler: { object -> Bool in
                    guard index != numberOfSamples else {
                        return true
                    }
                    let article = object as! Article
                    article.name = String(format: "Generated %05d", index)
                    article.creationDate = creationDate
                    article.lastModifiedDate = creationDate
                    article.source = .generated
                    article.views = Int.random(in: 0..<1000)
                    index += 1
                    return false
                })
                try taskContext.execute(insertRequest)
                
                try taskContext.save()
                taskContext.reset()

                print("### \(#function): Batch inserted \(numberOfSamples) posts")
            } catch {
                print("### \(#function): Failed to insert articles in batch: \(error)")
            }
        }
    }
}
