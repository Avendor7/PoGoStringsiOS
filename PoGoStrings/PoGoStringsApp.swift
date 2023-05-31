//
//  PoGoStringsApp.swift
//  PoGoStrings
//
//  Created by Stephen Wiggins on 2023-05-30.
//

import SwiftUI

@main
struct PoGoStringsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(newString: "Hello World")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
