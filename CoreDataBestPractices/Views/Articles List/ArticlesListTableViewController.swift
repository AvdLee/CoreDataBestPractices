//
//  ArticlesListTableViewController.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 02/11/2020.
//

import UIKit
import SwiftUI
import CoreData

final class ArticlesListTableViewController: UICollectionViewController {
    private enum Section: CaseIterable {
        case main
    }

    private let viewModel = ArticlesListViewModel()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, NSManagedObjectID> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, NSManagedObjectID> { cell, _, articleObjectID in
            guard let article = try? PersistentContainer.shared.viewContext.existingObject(with: articleObjectID) as? Article else { return }
            var content = cell.defaultContentConfiguration()
            content.text = article.name

            content.secondaryText = article.categoryName ?? "Uncategorized"
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)

            content.image = UIImage(systemName: "doc.plaintext")
            content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)

            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
            cell.tintColor = UIColor(named: "SwiftLee Orange")
        }

        return UICollectionViewDiffableDataSource<Section, NSManagedObjectID>(collectionView: collectionView) { (collectionView, indexPath, articleObjectID) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: articleObjectID)
        }
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<Article> = {
        let fetchedResultsController = NSFetchedResultsController<Article>(fetchRequest: viewModel.fetchRequest, managedObjectContext: PersistentContainer.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        super.init(collectionViewLayout: layout)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Categories", primaryAction: UIAction(handler: { _ in
            self.presentTagsView()
        }))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: UIAction(handler: { _ in
            self.showMoreOptions()
        }))
        setToolbarItems([
            UIBarButtonItem(title: "Add new article", primaryAction: UIAction(handler: { _ in
                self.presentAddArticleView()
            }))
        ], animated: true)
        navigationController?.setToolbarHidden(false, animated: false)
    }

    // MARK: Data Generation
    private func triggerDerivationExamples() {
        let category = Category(context: PersistentContainer.shared.viewContext)
        category.name = "SwiftUI"

        let article = Article(context: PersistentContainer.shared.viewContext)
        article.name = "A Title With Case and Díäcrîtįcs"
        article.category = category

        try! PersistentContainer.shared.viewContext.saveIfNeeded()

        print("Original name: \(article.name) derived name for searching: \(article.searchName)")
        print("Manual modified date: \(article.lastModifiedDate) derived modified date: \(article.derivedModifiedDate)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            article.name = "A new title"

            try! PersistentContainer.shared.viewContext.saveIfNeeded()

            print("Manual modified date: \(article.lastModifiedDate) derived modified date: \(article.derivedModifiedDate)")
        }
    }

    // MARK: Presenting Views
    private func showMoreOptions() {
        let alert = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Create 1000 articles", style: .default, handler: { _ in
            self.generateArticles()
        }))
        alert.addAction(UIAlertAction(title: "Derivation Example", style: .default, handler: { _ in
            self.triggerDerivationExamples()
        }))
        alert.addAction(UIAlertAction(title: "Delete All Articles", style: .destructive, handler: { _ in
            self.deleteAllArticles()
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

    private func generateArticles() {
        let category = Category(context: PersistentContainer.shared.viewContext)
        category.name = "SwiftUI"

        (0..<1000).forEach { index in
            let article = Article(context: PersistentContainer.shared.viewContext)
            article.name = "Generated \(index)"
            article.category = category
        }
        try! PersistentContainer.shared.viewContext.saveIfNeeded()
    }

    private func deleteAllArticles() {
        // Options 1:
//        try! Article.deleteAllOneByOne(in: PersistentContainer.shared.viewContext)

        // Options 2:
        try! Article.deleteAllInBatch(in: PersistentContainer.shared.viewContext)
    }
}

extension ArticlesListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>)
    }
}
