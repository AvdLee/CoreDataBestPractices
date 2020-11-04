//
//  ArticleFormView.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 02/11/2020.
//

import SwiftUI

struct ArticleFormView: View {

    let dismiss: () -> Void

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>

    @State var name: String = ""
    @State private var previewIndex = 0
    @State private var showingAlert = false
    @State private var errorDescription: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)

                    Picker("Category", selection: $previewIndex) {
                        ForEach(0 ..< categories.count) {
                            Text(categories[$0].name)
                        }
                    }
                }

                Section {
                    Button(action: {
                        addNewArticle()
                    }) {
                        Text("Add")
                    }
                }
            }
            .navigationBarTitle("Add Article")
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Saving failed"),
                    message: Text(errorDescription)
                )
            }
        }
    }

    func addNewArticle() {
        let article = Article(context: PersistentContainer.shared.viewContext)
        article.name = name
        article.category = categories[previewIndex]
        article.source = .manuallyAdded

        do {
            try PersistentContainer.shared.viewContext.saveIfNeeded()
            dismiss()
        } catch {
            PersistentContainer.shared.viewContext.delete(article)
            let localizedDescription = (error as? LocalizedError)?.recoverySuggestion ?? error.localizedDescription
            self.errorDescription =  localizedDescription
            showingAlert = true
        }
    }
}

struct ArticleFormView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleFormView(dismiss: { })
    }
}
