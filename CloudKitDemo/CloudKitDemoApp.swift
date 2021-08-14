//
//  CloudKitDemoApp.swift
//  CloudKitDemo
//
//  Created by Everett Wilber on 8/14/21.
//

import SwiftUI

@main
struct CloudKitDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
