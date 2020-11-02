//
//  ArticleFormView.swift
//  Core Data Best Practices
//
//  Created by Antoine van der Lee on 02/11/2020.
//

import SwiftUI

struct ArticleFormView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var username: String = ""
    @State var isPrivate: Bool = true
    @State var notificationsEnabled: Bool = false
    @State private var previewIndex = 0
    var previewOptions = ["Always", "When Unlocked", "Never"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("PROFILE")) {
                    TextField("Username", text: $username)
                    Toggle(isOn: $isPrivate) {
                        Text("Private Account")
                    }
                }

                Section(header: Text("NOTIFICATIONS")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enabled")
                    }
                    Picker(selection: $previewIndex, label: Text("Show Previews")) {
                        ForEach(0 ..< previewOptions.count) {
                            Text(self.previewOptions[$0])
                        }
                    }
                }

                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.2.1")
                    }
                }

                Section {
                    Button(action: {
                        print("Perform an action here...")
                    }) {
                        Text("Reset All Settings")
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct ArticleFormView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleFormView()
    }
}
