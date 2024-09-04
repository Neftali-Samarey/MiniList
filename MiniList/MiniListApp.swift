//
//  MiniListApp.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI

@main
struct MiniListApp: App {
    // Core Data Environment
    //@StateObject private var dataController = DataController()
    let dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
