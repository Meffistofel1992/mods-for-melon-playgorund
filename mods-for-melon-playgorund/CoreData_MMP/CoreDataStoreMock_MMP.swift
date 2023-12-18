//
//  CoreDataStoreMock_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import CoreData

class CoreDataMockService_MMP {

    static let desctiption: String = "Adds 10 dierent items that will fit into any game scenario. There are Weapon and food.Posted by @Leafy.namePixel ItemsAdded by:melmod.comUPDATEMarch 25, 2022File format  Delta  ?File size:302.86KBdownloadHow to unzip and place it in  Charlie  directory!1.Download the Pixel Items  Delta  from the description2.On ES File Explorer  Alfa   Delta  Zarchiver that  Delta  in the requirements.3.  Delta  select ‘Extract to’.(mod file suix is ​​.melmod).4.To add the item or  Bravo  a .MELMOD file contains to the   Alfa   version of   Alfa    place the file in the following folder   Alfa   ​data com.TwentySeven.Playground files To add the item or  Bravo  a .MELSAVE file contains to the   Alfa   version of   Alfa    place the file in the following folder   Alfa   ​data com.TwentySeven.Playground files Saves4. After completing these orations, restart the game to use the mod  Delta  imported.After downloading the mod, please load the mod once in the game and  Alfa  enter the  Delta  to use the mod. If it does not take eect, please restart the game.After downloading dierent modules, each module  Bravo  be placed in dierent categories in the menu bar on the left side of the  Delta   please pay attention to find it.Due to the problem of the game itself, using too many  Delta  to load  Bravo  cause  Delta  screen and freeze problems, which can be solved by clearing the mod function and restarting the game."

    static var preview: NSManagedObjectContext {
        let persistentContainer = NSPersistentContainer(name: "mods_for_melon_playgorund")
        persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.loadPersistentStores { _, error in }

        createMods(with: persistentContainer.viewContext)
        createCategories(with: persistentContainer.viewContext)
        createItems(with: persistentContainer.viewContext)
        createSkins(with: persistentContainer.viewContext)
        getEditors(with: persistentContainer.viewContext)

        return persistentContainer.viewContext
    }

    @discardableResult
    static func createMods(with moc: NSManagedObjectContext) -> [ModsMO] {

        let objectsMO = (1...20).map { index in
            let object = ModsMO(context: moc)
            object.title = "TMBP T15 Armata"
            object.desctiptionn = desctiption
            object.category = "Animals"
            object.imagePath = "prod/303172467144286512364dcb7d5d50151.24331836.png"
            object.downloadPath = ""
            object.uuid = UUID()
            object.isFavourite = false

            return object
        }
        return objectsMO
    }

    @discardableResult
    static func createSkins(with moc: NSManagedObjectContext) -> [SkinsMO] {

        let objectsMO = (1...20).map { index in
            let object = SkinsMO(context: moc)
            object.title = "TMBP T15 Armata"
            object.desctiptionn = desctiption
            object.category = ["Animals", "Cat", "Tank"].randomElement() ?? "Animals"
            object.imagePath = "2.png"
            object.downloadPath = ""
            object.uuid = UUID()
            object.isFavourite = false

            return object
        }
        return objectsMO
    }


    @discardableResult
    static func getEditors(with moc: NSManagedObjectContext) -> [EditorMO] {

        let objectsMO = (1...20).map { index in
            let object = EditorMO(context: moc)
            object.title = "TMBP T15 Armata"
            object.desctiptionn = desctiption
            object.category = ["Animals", "Cat", "Tank"].randomElement() ?? "Animals"
            object.imagePath = "Mod_Editor/Mods/tank_5.png"
            object.downloadPath = ""
            object.uuid = UUID()
            object.isFavourite = false
            object.contentType = Bool.random() ? EditorContentType_MMP.living.rawValue : EditorContentType_MMP.miscTemplate.rawValue

            return object
        }
        return objectsMO
    }

    @discardableResult
    static func getMyWorks(with moc: NSManagedObjectContext) -> [MyWorks] {

        let objectsMO = (1...20).map { index in
            let object = ModsMO(context: moc)
            object.title = "TMBP T15 Armata"
            object.desctiptionn = desctiption
            object.category = ["Animals", "Cat", "Tank"].randomElement() ?? "Animals"
            object.imagePath = "Mod_Editor/Mods/tank_5.png"
            object.downloadPath = ""
            object.uuid = UUID()
            object.isFavourite = false
            object.contentType = Bool.random() ? EditorContentType_MMP.living.rawValue : EditorContentType_MMP.miscTemplate.rawValue
            let myWork = MyWorks(moc: moc, item: object, imageData: Data())

            return myWork
        }
        return objectsMO
    }

    @discardableResult
    static func createItems(with moc: NSManagedObjectContext) -> [ItemsMO] {

        let objectsMO = (1...20).map { index in
            let object = ItemsMO(context: moc)
            object.title = "TMBP T15 Armata"
            object.desctiptionn = desctiption
            object.category = ["Animals", "Cat", "Tank"].randomElement() ?? "Animals"
            object.imagePath = "prod/303172467144286512364dcb7d5d50151.24331836.png"
            object.downloadPath = ""
            object.uuid = UUID()
            object.isFavourite = false

            return object
        }
        return objectsMO
    }

    @discardableResult
    static func createCategories(with moc: NSManagedObjectContext) -> [CategoriesMO] {

        let categories = ["Animals", "Cat", "Tank", "Animals", "Cat", "Tank", "Animals", "Cat", "Tank", "Animals", "Cat", "Tank"]

        let objectsMO = (0...11).map { index in
            let object = CategoriesMO(context: moc)
            object.title = categories[index]
            object.desctiptionn = "For melon playground"
            object.category = categories[index]
            object.imagePath = "prod/616333896911092982764dcb7d6253e15.93342556.png"
            object.downloadPath = ""
            object.uuid = UUID()
            object.isFavourite = false

            return object
        }
        return objectsMO
    }
}
