//
//  HomeDataAPI_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation
import Resolver

class HomeDataAPI_MMP {
    @Injected private var dropBoxManager: Dropbox_MMP
    @Injected private var coreDataStore: CoreDataStore_MMP
}

// MARK: - API Methods
extension HomeDataAPI_MMP {

    func getModels(type: ContentType_MMP) async throws {
        guard try await dropBoxManager.getMetaData_MMP(type: type) else {
            Logger.debug_MMP("\(type.rawValue) already getted")
            return
        }

        let json = try await dropBoxManager.downloadData_MMP(filePath: type.downloadPath).json()
        let models = switch type {
        case .mods, .editor:
            try getObjectsFromDict(json: json, type: type)
        case .category, .items, .skins:
            try getObjectsFromArrayDict(json: json, type: type)
        }
        await saveModels(type: type, data: models)

        Logger.debug_MMP("\(type.rawValue) get success")
    }
}

extension HomeDataAPI_MMP {
    private func getObjectsFromDict(json: [String : Any], type: ContentType_MMP) throws -> [LocalModel_MMP] {
        guard let structJson = json[type.mainKey] as? [String: Any] else {
            throw APIError_MMP.parseError(type)
        }

        var models: [LocalModel_MMP] = []

        for key in structJson.keys {
            if let model = structJson[key] as? [[String: Any]] {
                model.forEach { object in
                    switch type {
                    case .mods:
                        models.append(.init(modsObject: object, category: key))
                    case .editor:
                        models.append(.init(editorObject: object, contentType: Bool.random() ? .living : .miscTemplate))
                    default:
                        break
                    }
                }
            } else {
                if type != .editor {
                    throw APIError_MMP.parseError(type)
                }
            }
        }

        return models
    }

    private func getObjectsFromArrayDict(
        json: [String : Any],
        type: ContentType_MMP
    ) throws -> [LocalModel_MMP] {
        guard let structJson = json[type.mainKey] as? [[String: String]] else {
            throw APIError_MMP.parseError(type)
        }

        let objects: [LocalModel_MMP] = switch type {
        case .category:
            structJson.map { LocalModel_MMP(categoriesObject: $0) }
        case .items:
            structJson.map { LocalModel_MMP(itemObject: $0) }
        case .skins:
            structJson.map { LocalModel_MMP(skinObject: $0) }
        default: []
        }

        return objects
    }
}

// MARK: - CoreData methods
extension HomeDataAPI_MMP {
    private func saveModels(type: ContentType_MMP, data: [LocalModel_MMP]) async {
        await coreDataStore.viewContext.perform {

            self.coreDataStore.delete_MMP(entityName: type.entityName)
            
            data.forEach { object in
                let dataMO: ParentMO = switch type {
                case .mods:
                    ModsMO(context: self.coreDataStore.viewContext)
                case .category:
                    CategoriesMO(context: self.coreDataStore.viewContext)
                case .editor:
                    EditorMO(context: self.coreDataStore.viewContext)
                case .items:
                    ItemsMO(context: self.coreDataStore.viewContext)
                case .skins:
                    SkinsMO(context: self.coreDataStore.viewContext)
                }

                dataMO.title = object.title
                dataMO.desctiptionn = object.description
                dataMO.downloadPath = object.downloadPath
                dataMO.imagePath = object.imagePath
                dataMO.category = object.category
                dataMO.contentType = object.contentType?.rawValue
            }
            self.coreDataStore.saveChanges_MMP()
            Logger.debug_MMP("\(type) wtire to CoreData success")
        }
    }
}
