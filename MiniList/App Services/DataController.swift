//
//  DataController.swift
//  MiniList
//
//  Created by Neftali Samarey on 9/2/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MiniList")
    static let shared = DataController()

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

