//
//  dasd.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//

import Foundation

struct LocalModel_MMP {
    var title: String?
    var description: String?
    var imagePath: String?
    var downloadPath: String?

    init(modsObject: [String: Any]) {
        title = modsObject[ModsJsonKeys.title] as? String
        description = modsObject[ModsJsonKeys.description] as? String
        imagePath = modsObject[ModsJsonKeys.imagePath] as? String
        downloadPath = modsObject[ModsJsonKeys.downloadPath] as? String
    }

    init(categoriesObject: [String: Any]) {
        title = categoriesObject[CategoriesJsonKeys.title] as? String
        imagePath = categoriesObject[CategoriesJsonKeys.imagePath] as? String
    }

    init(editorObject: [String: Any]) {
        imagePath = editorObject[EditorJsonKeys.imagePath] as? String
    }

    init(itemObject: [String: Any]) {
        title = itemObject[ItemsJsonKeys.title] as? String
        description = itemObject[ItemsJsonKeys.description] as? String
        imagePath = itemObject[ItemsJsonKeys.imagePath] as? String
        downloadPath = itemObject[ItemsJsonKeys.downloadPath] as? String
    }

    init(skinObject: [String: Any]) {
        title = skinObject[SkinsJsonKeys.title] as? String
        description = skinObject[SkinsJsonKeys.description] as? String
        imagePath = skinObject[SkinsJsonKeys.imagePath] as? String
        downloadPath = skinObject[SkinsJsonKeys.downloadPath] as? String
    }
}