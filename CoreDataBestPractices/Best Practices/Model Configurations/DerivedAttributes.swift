//
//  DerivedAttributes.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 04/11/2020.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    /*
     This project contains several derived attributes:
     - Article.categoryName using 'category.name'
     - Article.searchName using 'canonical:(name)'
     - Article.derivedModifiedDate using 'now()'
     - Category.articlesCount using 'articles.@count'

     More info: https://www.avanderlee.com/core-data/derived-attributes-optimise-fetch-performance/

     */
    func demonstrateDerivedAttribute() {
        print("\n\n#####\n Derived Attributes Demonstration\n#####\n")
        let category = Category.insertSample(into: PersistentContainer.shared.viewContext)

        let article = Article(context: PersistentContainer.shared.viewContext)
        article.name = "A Title With Case and Díäcrîtįcs"
        article.category = category
        article.source = .generated
        article.views = Int.random(in: 0..<1000)

        try! PersistentContainer.shared.viewContext.saveIfNeeded()

        print("Original name: \(article.name) derived name for searching: \(article.searchName)")
        print("Manual modified date: \(article.lastModifiedDate) derived modified date: \(article.derivedModifiedDate)")
        print("Category name: \(article.category!.name) vs derived category name: \(article.categoryName!)")
        print("Category articles count: \(article.category!.articles.count) vs derived \(article.category!.articlesCount)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            article.name = "A new title"

            try! PersistentContainer.shared.viewContext.saveIfNeeded()

            print("Manual modified date: \(article.lastModifiedDate) derived modified date: \(article.derivedModifiedDate)")
        }
    }
}
