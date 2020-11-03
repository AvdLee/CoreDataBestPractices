//
//  Deletions.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func deleteAllOneByOne(in context: NSManagedObjectContext) throws {
        let fetchRequest = self.fetchRequest()
        let objects = try context.fetch(fetchRequest) as! [NSManagedObject]
        objects.forEach { object in
            context.delete(object)
        }
    }

    static func deleteAllInBatch(in context: NSManagedObjectContext) throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: self.fetchRequest())
        try context.execute(deleteRequest)
    }
}
