//
//  User.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 26/10/2020.
//

import Foundation
import CoreData

final class User: NSManagedObject, Identifiable {

    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var publicIdentifier: String!

    override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID().uuidString, forKey: #keyPath(User.publicIdentifier))
    }
}

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
}
