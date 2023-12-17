//
//  EditorController_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

enum EditorViewType: String, CaseIterable {
    case miscTemplates = "Misc templates"
    case setCollider = "Set collider"
    case selectTexture = "Select texture"
    case setProperties = "Set proprietes"
}

class EditorController_MMP: ObservableObject {
    @Published var selectionDropDownContent: DropDownSelection = .init()

    var dropDownContent: [DropDownSelection]

    init() {
        let dropDownContent: [DropDownSelection] = EditorViewType.allCases.map { DropDownSelection(value: $0) }

        self.dropDownContent = dropDownContent

        if let selectedCollection = dropDownContent.first {
            self.selectionDropDownContent = selectedCollection
        }
    }
}
