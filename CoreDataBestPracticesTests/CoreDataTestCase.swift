//
//  CoreDataTestCase.swift
//  CoreDataBestPracticesTests
//
//  Created by Antoine van der Lee on 06/11/2020.
//

import Foundation
import XCTest
import CoreData
@testable import Core_Data_Best_Practices

/// An abstract class to subclass for any Core Data related test classes.
class CoreDataTestCase: XCTestCase {

    private(set) var container: PersistentContainer!

    override func setUpWithError() throws {
        try super.setUpWithError()

        container = PersistentContainer(name: "DataModel", managedObjectModel: .sharedModel)
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.setup()
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }
}
