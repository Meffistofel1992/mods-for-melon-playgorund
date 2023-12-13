//
//  ParentMO+CoreDataProperties.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//
//

import Foundation
import CoreData


extension ParentMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParentMO> {
        return NSFetchRequest<ParentMO>(entityName: "ParentMO")
    }

    @NSManaged public var title: String?
    @NSManaged public var desctiptionn: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var downloadPath: String?
    @NSManaged public var category: String?
    @NSManaged public var uuid: UUID?

}

extension ParentMO : Identifiable {

}
