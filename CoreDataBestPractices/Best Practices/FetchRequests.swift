//
//  FetchRequests.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import Foundation
import CoreData

extension Article {
    @objc static func listAllFetchRequest() -> NSFetchRequest<Article> {
        // 'SELECT 0, t0.Z_PK, t0.Z_OPT, t0.ZCATEGORYNAME, t0.ZCREATIONDATE, t0.ZDERIVEDMODIFIEDDATE, t0.ZLASTMODIFIEDDATE, t0.ZLOCALRESOURCE, t0.ZNAME, t0.ZSEARCHNAME, t0.ZSOURCE, t0.ZCATEGORY FROM ZARTICLE t0'
        let fetchRequest = Article.fetchRequest

        // ORDER BY t0.ZNAME
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Article.name), ascending: false)]

        // LIMIT 20
        fetchRequest.fetchBatchSize = 20

        // 'SELECT 1, t0.Z_PK, t0.ZNAME, t0.ZCATEGORYNAME FROM ZARTICLE t0 WHERE  t0.Z_PK IN (SELECT * FROM _Z_intarray0)   LIMIT 20'
        fetchRequest.propertiesToFetch = [
            #keyPath(Article.name),
            #keyPath(Article.categoryName),
            #keyPath(Article.views)
        ]
        
        return fetchRequest
    }
}

/// Defines a convenience class for `NSManagedObject` types to add common methods and remove boilerplate code.
public protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
}

extension NSManagedObject: Managed { }
public extension Managed where Self: NSManagedObject {
    /// Returns a `String` of the entity name.
    static var entityName: String { return String(describing: self) }

    /// Creates a `NSFetchRequest` which can be used to fetch data of this type.
    static var fetchRequest: NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
}
