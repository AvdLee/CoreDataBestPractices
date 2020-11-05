//
//  PersistentHistoryCleaner.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

struct PersistentHistoryCleaner {

    let context: NSManagedObjectContext
    let targets: [AppTarget]
    let userDefaults: UserDefaults

    /// Cleans up the persistent history by deleting the transactions that have been merged into each target.
    func clean() throws {
        /// Add a timeinterval of 1 so we delete all transactions that are merged before and at the last common transaction timestamp.
        guard let timestamp = userDefaults.lastCommonTransactionTimestamp(in: targets)?.addingTimeInterval(1) else {
            print("Cancelling deletions as there is no common transaction timestamp")
            return
        }

        targets.forEach { target in
            /// Reset the dates as we would otherwise end up in an infinite loop.
            userDefaults.updateLastHistoryTransactionTimestamp(for: target, to: nil)
        }

        let deleteHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: timestamp)
        print("Deleting persistent history using common timestamp \(timestamp)")
        try context.execute(deleteHistoryRequest)
    }
}
