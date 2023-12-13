//
//  NSFetchRequest_MMP+Extension.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import CoreData

var modsPredicate: NSPredicate {
    let format: String = "ANY \(#keyPath(ModsMO.category)) == %@"
    return NSPredicate(format: format, "Animals")
}

extension NSFetchRequest where ResultType == ModsMO {
    static func mods(category: String) -> NSFetchRequest<ModsMO> {
        let request: NSFetchRequest<ModsMO> = ModsMO.fetchRequest()
        let format: String = "ANY \(#keyPath(ModsMO.category)) == %@"
        let predicate = NSPredicate(format: format, category)

        request.sortDescriptors = []
        request.predicate = predicate

        return request
    }
}

extension NSFetchRequest where ResultType == SkinsMO {
    static func skins() -> NSFetchRequest<SkinsMO> {
        let request: NSFetchRequest<SkinsMO> = SkinsMO.fetchRequest()
        request.sortDescriptors = []

        return request
    }
}

extension NSFetchRequest where ResultType == ItemsMO {
    static func items() -> NSFetchRequest<ItemsMO> {
        let request: NSFetchRequest<ItemsMO> = ItemsMO.fetchRequest()
        request.sortDescriptors = []

        return request
    }
}

extension NSFetchRequest where ResultType == CategoriesMO {
    static func categories() -> NSFetchRequest<CategoriesMO> {
        let request: NSFetchRequest<CategoriesMO> = CategoriesMO.fetchRequest()
        request.sortDescriptors = []

        return request
    }
}
