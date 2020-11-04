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
                            .font(.system(size: 12))
                            .padding(EdgeInsets(top: 4, leading: 7, bottom: 4, trailing: 7))
                            .foregroundColor(.white)
                            .background(Color(category.color))
                            .cornerRadius(3)
                        Text("Number of articles: \(category.articlesCount)")
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("Categories")
            .navigationBarItems(leading:
                Button("Add") {
                    Category.insertSample(into: managedObjectContext)
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
