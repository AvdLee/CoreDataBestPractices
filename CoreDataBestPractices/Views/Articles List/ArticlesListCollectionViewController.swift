//
//  ArticlesListCollectionViewController.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 02/11/2020.
//

import UIKit
import SwiftUI
import CoreData

final class ArticlesListCollectionViewController: UICollectionViewController {
    enum Section: CaseIterable {
        case main
    }

    private(set) lazy var dataSource: UICollectionViewDiffableDataSource<Section, NSManagedObjectID> = {
        let cellRegistration = UICollectionView.CellRegistration<ArticleListCell, NSManagedObjectID> { cell, indexPath, articleObjectID in
            guard let article = try? PersistentContainer.shared.viewContext.existingObject(with: articleObjectID) as? Article else { return }
            cell.article = article
        }

        return UICollectionViewDiffableDataSource<Section, NSManagedObjectID>(collectionView: collectionView) { (collectionView, indexPath, articleObjectID) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: articleObjectID)
        }
    }()

    private let fetchedResultsController: NSFetchedResultsController<Article> = .articlesFetchedResultsController()

    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        super.init(collectionViewLayout: layout)
        fetchedResultsController.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        setupBarButtonItems()
        try! fetchedResultsController.performFetch()
    }

    private func setupBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Categories", primaryAction: UIAction(handler: { [unowned self] _ in
            self.presentTagsView()
        }))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: UIAction(handler: { [unowned self] _ in
            self.showMoreOptions()
        }))
        setToolbarItems([
            UIBarButtonItem(title: "Stats", primaryAction: UIAction(handler: { [unowned self] _ in
                self.presentStatsView()
            })),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Add new article", primaryAction: UIAction(handler: { [unowned self] _ in
                self.presentAddArticleView()
            }))
        ], animated: true)
        navigationController?.setToolbarHidden(false, animated: false)
    }

    // MARK: Presenting Views
    private func showMoreOptions() {
        let alert = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Derivation Example", style: .default, handler: { _ in
            PersistentContainer.shared.viewContext.demonstrateDerivedAttribute()
        }))
        alert.addAction(UIAlertAction(title: "Threading Demo", style: .default, handler: { _ in
            PersistentContainer.shared.synchronousWork()
        }))
        alert.addAction(UIAlertAction(title: "Insert 1000 1 by 1", style: .default, handler: { _ in
            try! Article.insertSamplesOneByOne(1000)
        }))
        alert.addAction(UIAlertAction(title: "Insert 1000 In Batch", style: .default, handler: { _ in
            try! Article.insertSamplesInBatch(1000)
        }))
        alert.addAction(UIAlertAction(title: "Delete All 1 by 1", style: .destructive, handler: { _ in

            /// Use this to demonstrate a Core Data threading crash:
//            PersistentContainer.shared.deleteObjects(self.fetchedResultsController.fetchedObjects!)
//            PersistentContainer.shared.deleteObjectsWithIDs(self.fetchedResultsController.fetchedObjects!.map { $0.objectID })

             try! Article.deleteAllOneByOne()
        }))
        alert.addAction(UIAlertAction(title: "Delete All In Batch", style: .destructive, handler: { _ in
            try! Article.deleteAllInBatch()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func presentTagsView() {
        let categoriesView = CategoriesView().environment(\.managedObjectContext, PersistentContainer.shared.viewContext)
        let hostingController = UIHostingController(rootView: categoriesView)
        present(hostingController, animated: true, completion: nil)
    }

    private func presentAddArticleView() {
        let articleView = ArticleFormView(dismiss: { self.dismiss(animated: true) }).environment(\.managedObjectContext, PersistentContainer.shared.viewContext)
        let hostingController = UIHostingController(rootView: articleView)
        present(hostingController, animated: true, completion: nil)
    }

    private func presentStatsView() {
        let statsView = StatsView()
        let hostingController = UIHostingController(rootView: statsView)
        present(hostingController, animated: true, completion: nil)
    }
}
