//
//  SkinsMO+CoreDataProperties.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//
//

import Foundation
import CoreData


extension SkinsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SkinsMO> {
        return NSFetchRequest<SkinsMO>(entityName: "SkinsMO")
    }


}
