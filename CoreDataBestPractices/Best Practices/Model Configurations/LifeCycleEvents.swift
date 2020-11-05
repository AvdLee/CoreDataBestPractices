//
//  LifeCycleEvents.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import Foundation
import CoreData

extension Article {
    override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(Date(), forKey: #keyPath(Article.creationDate))
        setPrimitiveValue(Date(), forKey: #keyPath(Article.lastModifiedDate))
    }

    override func willSave() {
        super.willSave()

        setPrimitiveValue(Date(), forKey: #keyPath(Article.lastModifiedDate))

        if isDeleted, let localResource = localResource {
            do {
                /// Delete here instead of prepareForDeletion as you know for sure at this point that the entity is actually getting deleted.
                try FileManager.default.removeItem(at: localResource)
            } catch {
                print("Removing local file failed with error: \(error)")
            }
        }
    }

    override func prepareForDeletion() {
        super.prepareForDeletion()
        NetworkProvider.shared.cancelAllRequests(for: self)
    }
}

struct NetworkProvider {
    static let shared = NetworkProvider()

    func cancelAllRequests<T: Identifiable>(for identifiable: T) {

    }
}
