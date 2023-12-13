//
//  sdsad.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation

enum ContentType_MMP: String, CaseIterable, Identifiable {
    var id: Self { self }
    case mods = "Mods"
    case category = "Category"
    case editor = "Editor"
    case items = "Items"
    case skins = "Skins"

    static var home: [ContentType_MMP] = [.mods, .skins, .items]

    // paths to json file
    var downloadPath: String {
        switch self {
        case .mods: return "/Content/content.json"
        case .category: return "/categories/categories.json"
        case .editor: return "/mod_editor/mod_editor.json"
        case .items: return "/Items/Modified_Items.json"
        case .skins: return "/Skins/Modified_Skins.json"
        }
    }

    var folderName: String {
        switch self{
        case .mods:
            return "Content"
        case .items:
            return "Items"
        case .skins:
            return "Skins"
        default: return ""
        }
    }

    var mainKey: String {
        switch self {
        case .mods:
            return ModsJsonKeys.main
        case .category:
            return CategoriesJsonKeys.main
        case .editor:
            return EditorJsonKeys.main
        case .items:
            return ItemsJsonKeys.main
        case .skins:
            return SkinsJsonKeys.main
        }
    }

    var entityName: String {
        switch self {
        case .mods:
            return "ModsMO"
        case .category:
            return "CategoriesMO"
        case .editor:
            return "EditorMO"
        case .items:
            return "ItemsMO"
        case .skins:
            return "SkinsMO"
        }
    }
}
