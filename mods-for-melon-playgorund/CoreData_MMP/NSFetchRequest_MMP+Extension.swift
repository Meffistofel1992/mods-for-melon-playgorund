//
//  NSFetchRequest_MMP+Extension.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import CoreData

func modsPredicate(with category: String, searchText: String) -> NSPredicate {
    let categoryPredicate = NSPredicate(format: "%K == %@", #keyPath(ParentMO.category), category)
    let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate] + (searchText.isEmpty ? [] : [searchPredicate]) )

    return compoundPredicate
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
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CategoriesMO.title, ascending: true)]

        return request
    }
}
