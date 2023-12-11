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
        persistentContainer.loadPersistentStores { _, _ in }

//        createCharactersData(with: persistentContainer.viewContext)

        return persistentContainer.viewContext
    }

//    @discardableResult
//    static func createCharactersData(with moc: NSManagedObjectContext) -> [CharacterMO] {
//
//        let tasks = (1...20).map { index in
//            let character = CharacterMO(context: moc)
//            character.uuid = UUID()
//            character.isMock = index == 1
//            character.items = []
//
//            return character
//        }
//        return tasks
//    }
}
