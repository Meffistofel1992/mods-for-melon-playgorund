//
//  TempEditorModel.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 19.12.2023.
//

import Foundation

struct TempEditorModel {
    let name: String
    let imageData: Data
    let type: String
    let category: String
    let iconData: Data
    let xValue: String
    let yValue: String
    let heightValue: String
    let widthValue: String
    let pixelValue: Double
    let canBeTaken: Bool
    let canGlow: Bool
    let canBurn: Bool
    let canFloat: Bool

    init(myWorks: MyWorks) {
        self.name = myWorks.name ?? ""
        self.imageData = myWorks.imageData
        self.type = myWorks.type ?? ""
        self.category = myWorks.category ?? ""
        self.iconData = myWorks.iconData
        self.xValue = myWorks.xValue ?? ""
        self.yValue = myWorks.yValue ?? ""
        self.heightValue = myWorks.heightValue ?? ""
        self.widthValue = myWorks.widthValue ?? ""
        self.pixelValue = myWorks.pixelValue
        self.canBeTaken = myWorks.canBeTaken
        self.canGlow = myWorks.canGlow
        self.canBurn = myWorks.canBurn
        self.canFloat = myWorks.canFloat
    }

    func isDataEqual(rhs: MyWorks) -> Bool {
        let lhs = self
        return lhs.name == rhs.name &&
        lhs.imageData == rhs.imageData &&
        lhs.type == rhs.type &&
        lhs.category == rhs.category &&
        lhs.xValue == rhs.xValue &&
        lhs.yValue == rhs.yValue &&
        lhs.heightValue == rhs.heightValue &&
        lhs.widthValue == rhs.widthValue &&
        lhs.pixelValue == rhs.pixelValue &&
        lhs.canBeTaken == rhs.canBeTaken &&
        lhs.canGlow == rhs.canGlow &&
        lhs.canBurn == rhs.canBurn &&
        lhs.canFloat == rhs.canFloat &&
        lhs.iconData == rhs.iconData
    }
}
