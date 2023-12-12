//
//  ParentMO+CoreDataClass.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//
//

import Foundation
import CoreData

@objc(ParentMO)
public class ParentMO: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        uuid = UUID()
    }
}
