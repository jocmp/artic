//
//  Persistence.swift
//  Shared
//
//  Created by jocmp on 6/12/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

#if DEBUG
    static let testIDs = [
        UUID(),
        UUID(),
        UUID(),
        UUID(),
        UUID()
    ]
    
    static var sampleID: String {
        return testIDs.first!.uuidString
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for (idx, id) in testIDs.enumerated() {
            let newItem = Loan(context: viewContext)
            newItem.createdAt = Date()
            newItem.id = id
            newItem.name = "Loan #\(idx + 1)"
            newItem.currentAmount = 3000.00
            newItem.minimumPayment = 10.00
            newItem.interestRate = 5.0
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
#endif

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Artic")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
