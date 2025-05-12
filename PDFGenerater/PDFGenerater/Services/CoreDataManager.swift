//
//  CoreDataManager.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 11/05/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourDataModelName")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("CoreData Error: \(error)") }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreData Save Error: \(error)")
            }
        }
    }
}
