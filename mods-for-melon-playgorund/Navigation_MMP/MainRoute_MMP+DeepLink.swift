//
//  MainRoute_MMP+DeepLink.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation

enum MainRoute_MMP: Hashable {
    case tabView
    case detailMod(ParentMO, ContentType_MMP)
    case editor
}
