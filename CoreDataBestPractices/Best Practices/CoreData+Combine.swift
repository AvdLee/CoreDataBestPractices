//
//  CoreData+Combine.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import Foundation

extension ArticleListCell {

    /**
     Diffable Data Sources (DDS) are great but don't support reloads out of the box.
     You can support reloads with DDS with a bit more effort, read more about that here: https://www.avanderlee.com/swift/diffable-data-sources-core-data/

     Another option is to use Combine. This way, you can observe key paths as shown in this example.
     */

    func updateCombineObservers() {
        guard let article = article else { return }

        article.publisher(for: \.categoryName, options: .new).sink { [weak self] _ in
            self?.setNeedsUpdateConfiguration()
        }.store(in: &cancellables)
    }
}
