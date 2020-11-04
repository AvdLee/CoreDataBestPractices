//
//  Article.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 20/10/2020.
//

import Foundation
import CoreData

final class Article: NSManagedObject, Identifiable {

    @objc enum Source: Int64 {
        case unknown
        case manuallyAdded
        case generated
    }

    @NSManaged var name: String
    @NSManaged var creationDate: Date!
    @NSManaged var lastModifiedDate: Date
    @NSManaged var localResource: URL?
    @NSManaged var category: Category?

    // MARK: Transformables

    /// Enums can be stored without transformables. Just use @objc with an integer type.
    @NSManaged var source: Source

    // MARK: Derived Attributes
    /// Derived Attribute
    /// The derivation improves search performant by creating a name attribute with case and diacritics removed for more efficient comparison.
    /// Without this, unicode normalization would have to happen at search time, which is much slower than plain string matching would be.
    @NSManaged var searchName: String

    /// Derived Attribute using the key path `category.name`.
    @NSManaged var categoryName: String?

    /// Derived Attribute using `now()`.
    @NSManaged var derivedModifiedDate: Date

    // MARK: Live Cycle Events
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
