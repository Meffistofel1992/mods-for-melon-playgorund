//
//  CategoriesMO+CoreDataProperties.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//
//

import Foundation
import CoreData


extension CategoriesMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoriesMO> {
        return NSFetchRequest<CategoriesMO>(entityName: "CategoriesMO")
    }


}
