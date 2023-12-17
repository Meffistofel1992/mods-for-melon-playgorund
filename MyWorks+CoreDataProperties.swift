//
//  MyWorks+CoreDataProperties.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//
//

import Foundation
import CoreData


extension MyWorks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyWorks> {
        return NSFetchRequest<MyWorks>(entityName: "MyWorks")
    }
}
