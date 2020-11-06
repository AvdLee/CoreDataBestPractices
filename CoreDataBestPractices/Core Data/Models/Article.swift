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
    @NSManaged var views: Int
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
}
