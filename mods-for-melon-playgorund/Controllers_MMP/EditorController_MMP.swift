//
//  EditorController_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI
import CoreData

enum ImageState: Identifiable {
    var id: Self { self }

    case image
    case icon
}

enum EditorViewType: String, CaseIterable {
    case miscTemplates = "Misc templates"
    case setCollider = "Set collider"
    case selectTexture = "Set texture"
    case setProperties = "Set proprietes"
}

class EditorController_MMP: ObservableObject {
    @Published var selectionDropDownContent: DropDownSelection = .init()
    @Published var myMod: MyWorks
    @Published var progress: CGFloat = 0.6
    @Published var imageState: ImageState?

    var dropDownContent: [DropDownSelection]

    init(myMod: MyWorks) {
        let dropDownContent: [DropDownSelection] = EditorViewType.allCases.map { DropDownSelection(value: $0) }

        self.dropDownContent = dropDownContent

        if let selectedCollection = dropDownContent.first {
            self.selectionDropDownContent = selectedCollection
        }

        self.myMod = myMod
    }
}
