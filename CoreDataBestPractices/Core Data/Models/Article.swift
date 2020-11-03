//
//  Article.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 20/10/2020.
//

import Foundation
import CoreData

final class Article: NSManagedObject, Identifiable {

    enum Error: Swift.Error, LocalizedError {
        case protectedName(name: String)

        var recoverySuggestion: String? {
            switch self {
            case .protectedName(let name):
                return "The name '\(name)' is protected and can't be used."
            }
        }
    }

    static let protectedNames: [String] = ["swiftlee", "antoine", "nsspain"]

    @NSManaged var name: String
    @NSManaged var searchName: String
    @NSManaged var creationDate: Date!
    @NSManaged var derivedModifiedDate: Date
    @NSManaged var lastModifiedDate: Date
    @NSManaged var localResource: URL?
    @NSManaged var category: Category?
    @NSManaged var categoryName: String?

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

    override func validateForInsert() throws {
        try super.validateForInsert()
        
        guard !Self.protectedNames.contains(name.lowercased()) else {
            throw Error.protectedName(name: name)
        }
    }
}

struct NetworkProvider {
    static let shared = NetworkProvider()

    func cancelAllRequests<T: Identifiable>(for identifiable: T) {

    }
}
