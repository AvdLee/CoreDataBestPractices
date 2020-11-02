//
//  ArticlesListTableViewController.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 02/11/2020.
//

import UIKit
import SwiftUI

final class ArticlesListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Tags", primaryAction: UIAction(handler: { _ in
            self.presentTagsView()
        }))
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: UIBarButtonItem.SystemItem.add, primaryAction: UIAction(handler: { _ in
            self.presentAddArticleView()
        }))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    private func presentTagsView() {
        // Get the managed object context from the shared persistent container.
        let context = PersistentContainer.shared.viewContext

        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let tagsView = TagsView().environment(\.managedObjectContext, context)
        let hostingController = UIHostingController(rootView: tagsView)
        present(hostingController, animated: true, completion: nil)
    }

    private func presentAddArticleView() {
        
    }
}
