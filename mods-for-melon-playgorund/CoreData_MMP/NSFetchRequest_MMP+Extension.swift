//
//  NSFetchRequest_MMP+Extension.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import CoreData
//
//extension NSFetchRequest where ResultType == LocalDataMO {
//    static func getFavouriteItem(with menu: MenuItem_MMP) -> NSFetchRequest<LocalDataMO> {
//        let request: NSFetchRequest<LocalDataMO> = LocalDataMO.fetchRequest()
//        let menuPredicate: String = "ANY \(#keyPath(LocalDataMO.menu)) == %@"
//        let predicate = NSPredicate(format: menuPredicate, menu.rawValue)
//
//        request.sortDescriptors = []
//        request.predicate = predicate
//
//        return request
//    }
//}
