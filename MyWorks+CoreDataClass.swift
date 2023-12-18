//
//  MyWorks+CoreDataClass.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//
//

import Foundation
import CoreData

@objc(MyWorks)
public class MyWorks: NSManagedObject {
    convenience init(moc: NSManagedObjectContext, item: ParentMO, imageData: Data) {
        self.init(context: moc)
        self.name = item.titleOrEmpty
        self.imageData = imageData
        self.type = ""
        self.category = ""
        self.iconData = imageData
        self.xValue = ""
        self.yValue = ""
        self.heightValue = ""
        self.widthValue = ""
        self.pixelValue = 0
        self.canBeTaken = false
        self.canGlow = false
        self.canBurn = false
        self.canFloat = false
    }
}
