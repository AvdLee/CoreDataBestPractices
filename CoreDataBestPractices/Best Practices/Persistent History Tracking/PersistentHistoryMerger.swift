//
//  PersistentHistoryMerger.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

struct PersistentHistoryMerger {

    let backgroundContext: NSManagedObjectContext
    let viewContext: NSManagedObjectContext
    let currentTarget: AppTarget
    let userDefaults: UserDefaults

    func merge() throws {
        let fromDate = userDefaults.lastHistoryTransactionTimestamp(for: currentTarget) ?? .distantPast
        let fetcher = PersistentHistoryFetcher(fetchContext: backgroundContext, mergeContext: viewContext, fromDate: fromDate)
        let history = try fetcher.fetch()

        guard !history.isEmpty else {
            print("No history transactions found to merge for target \(currentTarget)")
            return
        }

        print("Merging \(history.count) persistent history transactions for target \(currentTarget)")

        viewContext.perform {
            history.merge(into: self.viewContext)
        }

        guard let lastTimestamp = history.last?.timestamp else { return }
        userDefaults.updateLastHistoryTransactionTimestamp(for: currentTarget, to: lastTimestamp)
    }
}

extension Collection where Element == NSPersistentHistoryTransaction {

    /// Merges the current collection of history transactions into the given managed object context.
    /// - Parameter context: The managed object context in which the history transactions should be merged.
    func merge(into context: NSManagedObjectContext) {
        forEach { transaction in
            context.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
        }
    }
}
