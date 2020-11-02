//
//  ContentView.swift
//  CoreDataBestPractices
//
//  Created by Antoine van der Lee on 20/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>

    var body: some View {
        NavigationView {
            VStack {
                List(users, id: \.self) { user in
                    VStack(alignment: .leading) {
                        Text(user.name ?? "Ghost")
                        Text(user.publicIdentifier)
                            .font(.footnote)
                    }
                }
            }
            .navigationBarTitle("Users")
            .navigationBarItems(leading:
                Button("Add") {
                    let user = User(context: managedObjectContext)
                    user.name = "Antoine van der Lee"
            }, trailing:
                Button("Save") {
                    try! self.managedObjectContext.save()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
