//
//  DiffableDataSources.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 04/11/2020.
//

import Foundation
import CoreData
import UIKit

/// Diffable Data Sources are supported when using a Fetched Results Controller.
/// Simply use the single delegate method available and apply the new snapshot.
///
/// Read more: https://www.avanderlee.com/swift/diffable-data-sources-core-data/
extension ArticlesListCollectionViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>, animatingDifferences: true)
    }
}
