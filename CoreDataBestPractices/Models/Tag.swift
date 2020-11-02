//
//  User.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 26/10/2020.
//

import Foundation
import CoreData
import UIKit

final class Tag: NSManagedObject, Identifiable {

    @NSManaged var name: String?
    @NSManaged var articlesCount: Int
}

extension Tag {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }
}
