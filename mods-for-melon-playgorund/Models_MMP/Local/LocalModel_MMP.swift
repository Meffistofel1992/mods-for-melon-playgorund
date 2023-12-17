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
    var category: String?
    var contentType: EditorContentType_MMP?

    init(modsObject: [String: Any], category: String?) {
        title = modsObject[ModsJsonKeys.title] as? String
        description = modsObject[ModsJsonKeys.description] as? String
        imagePath = modsObject[ModsJsonKeys.imagePath] as? String
        downloadPath = modsObject[ModsJsonKeys.downloadPath] as? String
        self.category = category
    }

    init(categoriesObject: [String: Any]) {
        title = categoriesObject[CategoriesJsonKeys.title] as? String
        imagePath = categoriesObject[CategoriesJsonKeys.imagePath] as? String
    }

    init(editorObject: [String: Any], contentType: EditorContentType_MMP) {
        imagePath = editorObject[EditorJsonKeys.imagePath] as? String
        self.contentType = contentType
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
