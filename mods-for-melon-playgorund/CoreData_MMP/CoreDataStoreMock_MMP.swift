//
//  CoreDataStoreMock_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import CoreData

class CoreDataMockService_MMP {

    static var preview: NSManagedObjectContext {
        let persistentContainer = NSPersistentContainer(name: "mods_for_melon_playgorund")
        persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.loadPersistentStores { _, error in }

        createMods(with: persistentContainer.viewContext)
        createCategories(with: persistentContainer.viewContext)

        return persistentContainer.viewContext
    }

    @discardableResult
    static func createMods(with moc: NSManagedObjectContext) -> [ModsMO] {

        let objectsMO = (1...20).map { index in
            let object = ModsMO(context: moc)
            object.title = "TMBP T15 Armata"
            object.desctiptionn = "For melon playground"
            object.category = "Animals"
            object.imagePath = ""
            object.downloadPath = ""
            object.uuid = UUID()

            return object
        }
        return objectsMO
    }

    @discardableResult
    static func createCategories(with moc: NSManagedObjectContext) -> [CategoriesMO] {

        let objectsMO = (1...20).map { index in
            let object = CategoriesMO(context: moc)
            object.title = "TMBP T15 Armata"
            object.desctiptionn = "For melon playground"
            object.category = "Animals"
            object.imagePath = ""
            object.downloadPath = ""
            object.uuid = UUID()

            return object
        }
        return objectsMO
    }
}
