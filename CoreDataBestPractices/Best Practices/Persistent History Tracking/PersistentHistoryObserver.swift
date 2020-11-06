//
//  PersistentHistoryObserver.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import Foundation
import CoreData

public enum AppTarget: String, CaseIterable {
    /// The main app making use of the data.
    case app

    /// An optional extension that could also make use of the same database.
    case shareExtension
}

public final class PersistentHistoryObserver {

    private let target: AppTarget
    private let userDefaults: UserDefaults
    private let persistentContainer: NSPersistentContainer

    /// An operation queue for processing history transactions.
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    public init(target: AppTarget, persistentContainer: NSPersistentContainer, userDefaults: UserDefaults) {
        self.target = target
        self.userDefaults = userDefaults
        self.persistentContainer = persistentContainer
    }

    public func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(processStoreRemoteChanges), name: .NSPersistentStoreRemoteChange, object: persistentContainer.persistentStoreCoordinator)
    }

    /// Process persistent history to merge changes from other coordinators.
    @objc private func processStoreRemoteChanges(_ notification: Notification) {
        historyQueue.addOperation { [weak self] in
            self?.processPersistentHistory()
        }
    }

    @objc private func processPersistentHistory() {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            do {
                let merger = PersistentHistoryMerger(backgroundContext: context, viewContext: persistentContainer.viewContext, currentTarget: target, userDefaults: userDefaults)
                try merger.merge()

                let cleaner = PersistentHistoryCleaner(context: context, targets: AppTarget.allCases, userDefaults: userDefaults)
                try cleaner.clean()
            } catch {
                print("Persistent History Tracking failed with error \(error)")
            }
        }
    }
}

extension UserDefaults {

    func lastHistoryTransactionTimestamp(for target: AppTarget) -> Date? {
        let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
        return object(forKey: key) as? Date
    }

    func updateLastHistoryTransactionTimestamp(for target: AppTarget, to newValue: Date?) {
        let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
        set(newValue, forKey: key)
    }

    func lastCommonTransactionTimestamp(in targets: [AppTarget]) -> Date? {
        guard targets.count > 1 else { return lastHistoryTransactionTimestamp(for: targets.first!) }
        let timestamp = targets
            .map { lastHistoryTransactionTimestamp(for: $0) ?? .distantPast }
            .min() ?? .distantPast
        return timestamp > .distantPast ? timestamp : nil
    }
}
