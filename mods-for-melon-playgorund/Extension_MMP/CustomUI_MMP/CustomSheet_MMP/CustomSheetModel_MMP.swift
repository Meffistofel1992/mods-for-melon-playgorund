//
//  CustomSheetModel.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 17.11.2023.
//

import Foundation

struct CustomSheetModel_MMP {
    let type: SheetType_MMP
    let firstAction: ValueClosure_MMP<CustomSheetAction_MMP>
    let secondAction: ValueClosure_MMP<CustomSheetAction_MMP>
}

enum SheetType_MMP {
    case loading
}

enum CustomSheetAction_MMP {
    case cancel
}
