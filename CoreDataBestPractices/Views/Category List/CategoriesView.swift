//
//  CategoriesView.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 20/10/2020.
//

import SwiftUI

struct CategoriesView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>

    var body: some View {
        NavigationView {
            VStack {
                List(categories, id: \.self) { category in
                    VStack(alignment: .leading) {
                        Text(category.name)
                        Text("Number of articles: \(category.articlesCount)")
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("Categories")
            .navigationBarItems(leading:
                Button("Add") {
                    let user = Category(context: managedObjectContext)
                    user.name = "SwiftUI"
            }, trailing:
                Button("Save") {
                    try! self.managedObjectContext.save()
            })
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
