//
//  StatsFetching.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import Foundation
import CoreData

extension Article {
    // MARK: - Count Fetching
    static func totalNumber(in context: NSManagedObjectContext) -> Int {
        // Wrong:
        let fetchRequest = Article.fetchRequest()
        let count = try! context.fetch(fetchRequest).count

        // Good:
        let countRequest = try! context.count(for: Article.fetchRequest)

        print("Total articles count is \(count) and count request: \(countRequest)")

        return countRequest
    }

    // MARK: - Limited Objects Fetching
    static func newest(in context: NSManagedObjectContext) -> Article? {
        // Wrong:
        let fetchRequest = Article.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Article.creationDate, ascending: false)]

        let wrongFirstArticle = try! context.fetch(fetchRequest).first as? Article

        // Good:
        fetchRequest.fetchLimit = 1
        let goodFirstArticle = try! context.fetch(fetchRequest).first as? Article

        print("Wrong fetched article \(wrongFirstArticle?.name ?? ""), correctly fetched \(goodFirstArticle?.name ?? "")")

        return goodFirstArticle
    }

    // MARK: - Filtered Fetching
    static func articlesAddedToday(in context: NSManagedObjectContext) -> Int {
        let fetchRequest = Article.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Article.creationDate, ascending: false)]

        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        // Today's beginning date.
        let todaysDate = calendar.startOfDay(for: Date())

        fetchRequest.predicate = NSPredicate(format: "%K >= %@", #keyPath(Article.creationDate), todaysDate as NSDate)

        return try! context.count(for: fetchRequest)
    }

    // MARK: - Aggregate Fetching
    static func categoriesTotalViews(in context: NSManagedObjectContext) -> [[String: AnyObject]] {
        var expressionDescriptions = [AnyObject]()

        // We want the category name to be one of the columns returned, so we're just adding it as a key path.
        let categoryExpressionDescription = NSExpressionDescription()
        categoryExpressionDescription.name = "Category"
        categoryExpressionDescription.expression = NSExpression(format: "categoryName")
        expressionDescriptions.append(categoryExpressionDescription)

        // Create an expression description for the views column
        let expressionDescription = NSExpressionDescription()

        // This is the name that will be returned as a key in the dictionary result
        expressionDescription.name = "Views"

        // Use an aggregate function to calculate the value of our column.
        expressionDescription.expression = NSExpression(format: "@sum.views")

        // Specify the return type we expect. Without setting this to an integer it can result in .0 decimals.
        expressionDescription.expressionResultType = .integer64AttributeType
        expressionDescriptions.append(expressionDescription)

        let request = Article.fetchRequest()

        // The column to group the results by. Without this, we would end up with as many results as Articles.
        // We use the category column which is non-aggregate and consistent for grouping.
        request.propertiesToGroupBy = ["categoryName"]

        // We need to set the result type to dictionary to be able to use `propertiesToGroupBy`.
        request.resultType = .dictionaryResultType

        // Sorting on the category name to get an alphabetical result.
        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]

        // Filter down the results to the configured expressions so we only get those returned.
        request.propertiesToFetch = expressionDescriptions

        return try! context.fetch(request) as? [[String: AnyObject]] ?? []
    }
}
