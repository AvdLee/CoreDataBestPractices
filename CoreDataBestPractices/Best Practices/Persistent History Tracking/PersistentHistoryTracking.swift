//
//  PersistentHistoryTracking.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

extension PersistentContainer {
    func enablePersistentHistoryTracking() {
        let storeDescription = persistentStoreDescriptions.first!

        /// Enable Persistent History Tracking
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        /// Register to receive remote change notifications
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        persistentStoreDescriptions = [storeDescription]
    }

    func startObservingPersistentHistoryTransactions() -> PersistentHistoryObserver {
        let observer = PersistentHistoryObserver(target: .app, persistentContainer: self, userDefaults: .standard)

        viewContext.name = "view_context"
        viewContext.transactionAuthor = "main_app_view_context"

        observer.startObserving()
        return observer
    }
}
