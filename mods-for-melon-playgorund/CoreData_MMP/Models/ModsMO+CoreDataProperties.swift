//
//  ModsMO+CoreDataProperties.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//
//

import Foundation
import CoreData


extension ModsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModsMO> {
        return NSFetchRequest<ModsMO>(entityName: "ModsMO")
    }


}
