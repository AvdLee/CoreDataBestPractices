//
//  Stack.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import Foundation
import CoreData

final class PersistentContainer: NSPersistentContainer {

    static let shared = PersistentContainer(name: "DataModel", managedObjectModel: .sharedModel)

    private var persistentHistoryObserver: PersistentHistoryObserver?

    func setup() {
        registerValueTransformers()
        enablePersistentHistoryTracking()

        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        persistentHistoryObserver = startObservingPersistentHistoryTransactions()
    }

    /// A convenience method for creating background contexts that specify the app as their transaction author.
    /// It's best practice to perform heavy lifting on a background context.
    ///
    /// - Returns: The background context configured with a name and transaction author.
    override func newBackgroundContext() -> NSManagedObjectContext {
        let context = super.newBackgroundContext()
        context.name = "background_context"
        context.transactionAuthor = "main_app_background_context"
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}
