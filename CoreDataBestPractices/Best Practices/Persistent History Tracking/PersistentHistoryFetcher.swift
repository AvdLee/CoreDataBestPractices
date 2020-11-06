//
//  PersistentHistoryFetcher.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

struct PersistentHistoryFetcher {

    enum Error: Swift.Error {
        /// In case that the fetched history transactions couldn't be converted into the expected type.
        case historyTransactionConvertionFailed
    }

    let fetchContext: NSManagedObjectContext
    let mergeContext: NSManagedObjectContext
    let fromDate: Date

    func fetch() throws -> [NSPersistentHistoryTransaction] {
        let fetchRequest = createFetchRequest()

        guard let historyResult = try fetchContext.execute(fetchRequest) as? NSPersistentHistoryResult, let history = historyResult.result as? [NSPersistentHistoryTransaction] else {
            throw Error.historyTransactionConvertionFailed
        }

        return history
    }

    func createFetchRequest() -> NSPersistentHistoryChangeRequest {
        let historyFetchRequest = NSPersistentHistoryChangeRequest
            .fetchHistory(after: fromDate)

        if let fetchRequest = NSPersistentHistoryTransaction.fetchRequest {
            var predicates: [NSPredicate] = []

            if let transactionAuthor = mergeContext.transactionAuthor {
                /// Only look at transactions created by other targets.
                predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.author), transactionAuthor))
            }
            if let contextName = mergeContext.name {
                /// Only look at transactions not from our current context.
                predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.contextName), contextName))
            }

            fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
            historyFetchRequest.fetchRequest = fetchRequest
        }

        return historyFetchRequest
    }
}
