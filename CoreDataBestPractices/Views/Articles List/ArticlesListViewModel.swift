//
//  ArticlesListViewModel.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 02/11/2020.
//

import Foundation
import CoreData

final class ArticlesListViewModel {

    let fetchRequest: NSFetchRequest<Article>

    init() {
        /// Presentation: rewrite this using 'Managed'.
        fetchRequest = NSFetchRequest<Article>(entityName: "Article")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Article.name), ascending: true)]
        fetchRequest.fetchBatchSize = 10
    }
}
