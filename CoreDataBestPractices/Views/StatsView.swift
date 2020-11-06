//
//  StatsView.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 05/11/2020.
//

import SwiftUI
import CoreData

struct StatsView: View {

    let viewModel = StatsViewModel()

    var body: some View {
        NavigationView {
            List {
                StatsListView(key: "Total articles", value: "\(viewModel.totalArticles)")
                StatsListView(key: "Newest article", value: "\(viewModel.newestArticle)")
                StatsListView(key: "Articles added today", value: "\(viewModel.articlesAddedToday)")

                Section(header: Text("Category Views").padding(.top)) {
                    ForEach(viewModel.categoriesTotalViews, id: \.self) { (dictionary) in
                        StatsListView(key: dictionary["Category"]!, value: dictionary["Views"]!)
                    }
                }
            }
                .listStyle(GroupedListStyle())
                .navigationTitle("Article Stats")
        }
    }
}

struct StatsListView: View {
    let key: String
    let value: String

    var body: some View {
        HStack {
            Text("\(key):").bold()
            Spacer()
            Text("\(value)")
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

struct StatsViewModel {

    let totalArticles: Int
    let newestArticle: String
    let articlesAddedToday: Int
    let categoriesTotalViews: [[String: String]]

    init(context: NSManagedObjectContext = PersistentContainer.shared.viewContext) {
        totalArticles = Article.totalNumber(in: context)
        newestArticle = Article.newest(in: context)?.name ?? "Not found"
        articlesAddedToday = Article.articlesAddedToday(in: context)
        categoriesTotalViews = Article.categoriesTotalViews(in: context).map { dictionary in
            dictionary.mapValues { String(describing: $0) }
        }
    }
}
