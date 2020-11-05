//
//  FetchedResultsController.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 04/11/2020.
//

import Foundation
import CoreData

extension NSFetchedResultsController {

    @objc static func articlesFetchedResultsController() -> NSFetchedResultsController<Article> {
        /// Presentation: rewrite this using 'Managed'.
        let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Article.name), ascending: true)]
        fetchRequest.fetchBatchSize = 10
        fetchRequest.fetchLimit = 5

        return NSFetchedResultsController<Article>(fetchRequest: fetchRequest, managedObjectContext: PersistentContainer.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}
