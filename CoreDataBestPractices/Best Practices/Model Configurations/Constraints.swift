//
//  Constraints.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 04/11/2020.
//

import Foundation
import CoreData
import UIKit

extension Category {

    /*
     Open the demo app categories page to see this in action:
     1. Press the add button several times
     2. See multiple SwiftUI Categories arrive
     3. Press save
     4. Only 1 SwiftUI category is left

     This is done by having a constraint configured for the `name` attribute to be unique.

     More info: https://www.avanderlee.com/swift/constraints-core-data-entities/
     */
    @discardableResult static func insertSample(into context: NSManagedObjectContext) -> Category {
        let category = Category(context: context)
        category.name = "SwiftUI"
        category.color = UIColor(named: "SwiftLee Orange")!
        return category
    }

}
