//
//  CoreDataStore_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation
import CoreData

private let modelFileName: String = "mods_for_melon_playgorund"

class CoreDataStore_MMP: NSPersistentContainer {

    lazy var backgroundObjectContext: NSManagedObjectContext = {
        viewContext.automaticallyMergesChangesFromParent = true

        return newBackgroundContext()
    }()

    init(name: String = modelFileName) {
        guard let model: NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil) else {
            fatalError("Can't load managed object models from bundle")
        }
        super.init(name: name, managedObjectModel: model)

        loadPersistentStores(completionHandler: { (_, error) in
            if let error: NSError = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        viewContext.mergePolicy = NSOverwriteMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension CoreDataStore_MMP {

    func numberOfElements_MMP<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> Int {
        do {
            return try viewContext.count(for: fetchRequest)
        } catch let error {
            Logger.error_MMP(error)
            return 0
        }
    }

    func MMP_deleteObject_MMP(object: NSManagedObject) {
        viewContext.delete(object)
    }

    private func delete_MMP(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
        } catch let error as NSError {
            Logger.error_MMP(error)
        }
    }

    func fetch_MMP<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        do {
            return try viewContext.fetch(request)
        } catch {
            Logger.error_MMP(error)
            return nil
        }
    }

    func fetchExistingObject_MMP<T: NSManagedObject>(with objectID: NSManagedObjectID) -> T? {
        do {
            return try viewContext.existingObject(with: objectID) as? T
        } catch {
            Logger.error_MMP(error)
            return nil
        }
    }

    func saveChanges_MMP() {
        guard viewContext.hasChanges else {
            return
        }

        do {
            try viewContext.save()
        } catch {
            Logger.error_MMP(error)
        }
    }

    func MMP_resetContext_MMP() {
        viewContext.reset()
    }
}
