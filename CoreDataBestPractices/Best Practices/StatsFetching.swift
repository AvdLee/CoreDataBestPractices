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
        let countRequest = try! PersistentContainer.shared.viewContext.count(for: Article.fetchRequest)

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

    // MARK: - Aggregate Fetching
    static func categoriesTotalViews(in context: NSManagedObjectContext) -> [[String: AnyObject]] {
        var expressionDescriptions = [AnyObject]()

        // We want productLine to be one of the columns returned, so just add it as a string
        let categoryExpressionDescription = NSExpressionDescription()
        categoryExpressionDescription.name = "Category"
        categoryExpressionDescription.expression = NSExpression(format: "categoryName")
        expressionDescriptions.append(categoryExpressionDescription)

        // Create an expression description for our SoldCount column
        let expressionDescription = NSExpressionDescription()
        // Name the column
        expressionDescription.name = "Views"
        // Use an expression to specify what aggregate action we want to take and
        // on which column. In this case sum on the sold column
        expressionDescription.expression = NSExpression(format: "@sum.views")
        // Specify the return type we expect
        expressionDescription.expressionResultType = .integer64AttributeType
        // Append the description to our array
        expressionDescriptions.append(expressionDescription)

        // Build out our fetch request the usual way
        let request = Article.fetchRequest()
        // This is the column we are grouping by. Notice this is the only non aggregate column.
        request.propertiesToGroupBy = ["categoryName"]
        // Specify we want dictionaries to be returned
        request.resultType = .dictionaryResultType
        // Go ahead and specify a sorter
        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        // Hand off our expression descriptions to the propertiesToFetch field. Expressed as strings
        // these are ["productLine", "SoldCount", "ReturnedCount"] where productLine is the value
        // we are grouping by.
        request.propertiesToFetch = expressionDescriptions

        return try! context.fetch(request) as? [[String: AnyObject]] ?? []
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
}
