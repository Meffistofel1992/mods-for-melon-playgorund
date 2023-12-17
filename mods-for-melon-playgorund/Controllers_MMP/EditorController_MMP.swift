//
//  EditorController_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI
import CoreData

enum EditorViewType: String, CaseIterable {
    case miscTemplates = "Misc templates"
    case setCollider = "Set collider"
    case selectTexture = "Set texture"
    case setProperties = "Set proprietes"
}

class EditorController_MMP: ObservableObject {
    @Published var selectionDropDownContent: DropDownSelection = .init()
    @Published var myMod: MyWorks
    @Published var nameText: String = ""
    @Published var progress: CGFloat = 0.6

    var dropDownContent: [DropDownSelection]

    init(moc: NSManagedObjectContext) {
        let dropDownContent: [DropDownSelection] = EditorViewType.allCases.map { DropDownSelection(value: $0) }

        self.dropDownContent = dropDownContent

        if let selectedCollection = dropDownContent.first {
            self.selectionDropDownContent = selectedCollection
        }

        myMod = .init(context: moc)
    }
}
