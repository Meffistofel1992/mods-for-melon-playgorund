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

    @NSManaged public var name: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var type: String?
    @NSManaged public var category: String?
    @NSManaged public var iconData: Data?
    @NSManaged public var xValue: String?
    @NSManaged public var yValue: String?
    @NSManaged public var heightValue: String?
    @NSManaged public var widthValue: String?
    @NSManaged public var pixelValue: String?
    @NSManaged public var canBeTaken: Bool
    @NSManaged public var canGlow: Bool
    @NSManaged public var canBurn: Bool
    @NSManaged public var canFloat: Bool
}

extension MyWorks : Identifiable {

}
