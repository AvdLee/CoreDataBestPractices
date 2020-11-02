//
//  TagsView.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 20/10/2020.
//

import SwiftUI

struct TagsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags: FetchedResults<Tag>

    var body: some View {
        NavigationView {
            VStack {
                List(tags, id: \.self) { tag in
                    VStack(alignment: .leading) {
                        Text(tag.name ?? "Ghost")
                        Text(tag.publicIdentifier)
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("Tags")
            .navigationBarItems(leading:
                Button("Add") {
                    let user = Tag(context: managedObjectContext)
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
        TagsView()
    }
}
