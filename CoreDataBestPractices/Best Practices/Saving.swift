//
//  Saving.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 04/11/2020.
//

import Foundation
import CoreData

/**
 In general: Save only if needed.
 The `saveIfNeeded` method below will help to achieve this automatically.
 Apart from that, you can still focus on calling this method only if needed.
 However, do consider: your data is only saved if you save :-)

 Another good practice is to save on termination & on background.
 See: `SceneDelegate.sceneDidEnterBackground(_:)`
 */
extension NSManagedObjectContext {

    /// Checks whether there are actually changes that will change the persistent store.
    /// The `hasChanges` method would return `true` for transient changes as well which can lead to false positives.
    var hasPersistentChanges: Bool {
        return !insertedObjects.isEmpty || !deletedObjects.isEmpty || updatedObjects.contains(where: { $0.hasPersistentChangedValues })
    }

    /// Saves the context, only if it has any changes and if it has a place to save the changes to (parent or persistent store). Calling this method instead of the regular save() will increase performance. It is also useful to use this function when having a memory store, since this configuration doesn't have a persistent store but may use parent contexts to save their changes to.
    /// - throws: A Core Data NSError when saving fails.
    /// - returns: Whether the save was needed.
    @discardableResult public func saveIfNeeded() throws -> Bool {
        let hasPurpose = parent != nil || persistentStoreCoordinator?.persistentStores.isEmpty == false
        guard hasPersistentChanges && hasPurpose else {
            // Saving won't do anything now, except for decreasing performance. Skip it for now.
            return false
        }

        try save()

        return true
    }
}
