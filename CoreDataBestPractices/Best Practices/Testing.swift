//
//  Testing.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 06/11/2020.
//

import Foundation
import CoreData

extension NSManagedObjectModel {
    /// We use this static shared model to prevent errors like:
    /// `Failed to find a unique match for an NSEntityDescription to a managed object subclass`
    ///
    /// This error likely occurs when running tests with an in-memory store while the regular app launch loads a file backed store.
    static let sharedModel: NSManagedObjectModel = {
        let url = Bundle(for: PersistentContainer.self).url(forResource: "DataModel", withExtension: "momd")!
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Managed object model could not be created.")
        }
        return managedObjectModel
    }()
}
