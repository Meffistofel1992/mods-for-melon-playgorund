//
//  ItemsMO+CoreDataProperties.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//
//

import Foundation
import CoreData


extension ItemsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemsMO> {
        return NSFetchRequest<ItemsMO>(entityName: "ItemsMO")
    }


}
