//
//  EditorMO+CoreDataProperties.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//
//

import Foundation
import CoreData


extension EditorMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditorMO> {
        return NSFetchRequest<EditorMO>(entityName: "EditorMO")
    }


}
