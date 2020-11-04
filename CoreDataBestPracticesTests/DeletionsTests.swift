//
//  DeletionsTests.swift
//  CoreDataBestPracticesTests
//
//  Created by Antoine van der Lee on 03/11/2020.
//

import XCTest
import CoreData
@testable import Core_Data_Best_Practices

final class DeletionsTests: XCTestCase {

    private var context: NSManagedObjectContext!
    private let numberOfSamples = 10000
    private lazy var objects: [[String: Any]] = {
        let creationDate = Date()
        return (0..<numberOfSamples).map { index -> [String: Any] in
            return [
                "name": String(format: "Generated %05d", index),
                "creationDate": creationDate,
                "lastModifiedDate": creationDate
            ]
        }
    }()
    override func setUp() {
        super.setUp()

        context = PersistentContainer.shared.viewContext
    }

    override func tearDown() {
        super.tearDown()
        context = nil
    }

    func testInsertionTimePerformance() throws {
        measure(metrics: [XCTClockMetric()]) {
//            try! Article.insertSamplesOneByOne(numberOfSamples, into: self.context)
            try! Article.insertObjectsInBatch(objects, into: self.context)
        }
    }

    func testInsertionMemoryPerformance() throws {
        measure(metrics: [XCTMemoryMetric()]) {
//            try! Article.insertSamplesOneByOne(numberOfSamples, into: self.context)
            try! Article.insertObjectsInBatch(objects, into: self.context)
        }
    }

}
