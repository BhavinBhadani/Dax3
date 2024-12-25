//
//  Dax3App.swift
//  Dax3
//
//  Created by Bhavin Bhadani on 25/12/24.
//

import SwiftUI

@main
struct Dax3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
