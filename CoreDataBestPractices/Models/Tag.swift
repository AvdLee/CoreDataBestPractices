//
//  User.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 26/10/2020.
//

import Foundation
import CoreData

final class Tag: NSManagedObject, Identifiable {

    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var publicIdentifier: String!

    override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID().uuidString, forKey: #keyPath(Tag.publicIdentifier))
    }
}

extension Tag {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }
}
