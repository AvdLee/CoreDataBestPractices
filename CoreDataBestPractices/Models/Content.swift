//
//  Content.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 20/10/2020.
//

import Foundation
import CoreData

final class Content: NSManagedObject, Identifiable {

    @NSManaged var name: String?
    @NSManaged var publicIdentifier: String!
    @NSManaged var creationDate: Date!
    @NSManaged var lastModifiedDate: Date!
    @NSManaged var localResource: URL?

    override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID().uuidString, forKey: #keyPath(Content.publicIdentifier))
        setPrimitiveValue(Date(), forKey: #keyPath(Content.creationDate))
        setPrimitiveValue(Date(), forKey: #keyPath(Content.lastModifiedDate))
    }

    override func willSave() {
        super.willSave()
        setPrimitiveValue(Date(), forKey: #keyPath(Content.lastModifiedDate))

        if isDeleted, let localResource = localResource {
            do {
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

extension Content {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }
}

struct NetworkProvider {
    static let shared = NetworkProvider()

    func cancelAllRequests<T: Identifiable>(for identifiable: T) {

    }
}
