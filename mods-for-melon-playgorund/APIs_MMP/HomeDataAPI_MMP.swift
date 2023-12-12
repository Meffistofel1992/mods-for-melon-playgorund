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

    func getObjectsFromDict(json: [String : Any], type: ContentType_MMP) throws -> [LocalModel_MMP] {
        guard let structJson = json[type.mainKey] as? [String: Any] else {
            throw APIError_MMP.parseError(type)
        }

        var models: [LocalModel_MMP] = []

        for key in structJson.keys {
            if let model = structJson[key] as? [[String: Any]] {
                model.forEach { object in
                    models.append(.init(modsObject: object))
                }
            } else {
                if type != .editor {
                    throw APIError_MMP.parseError(type)
                }
            }
        }

        return models
    }

    func getObjectsFromArrayDict(
        json: [String : Any],
        type: ContentType_MMP
    ) throws -> [LocalModel_MMP] {
        guard let structJson = json[type.mainKey] as? [[String: String]] else {
            throw APIError_MMP.parseError(type)
        }
        let objects = structJson.map { LocalModel_MMP(modsObject: $0) }

        return objects
    }

    func getMods_MMP(type: ContentType_MMP = .mods) async throws {

        guard try await dropBoxManager.getMetaData_MMP(type: type) else {
            Logger.debug_MMP("Mods already getted")
            return
        }
        let json = try await dropBoxManager.downloadData_MMP(filePath: type.downloadPath).json()
        let mods = try getObjectsFromDict(json: json, type: type)
        await saveModels(type: type, data: mods)

        Logger.debug_MMP("Maps get success")

    }

    func getCategories_MMP(type: ContentType_MMP = .category) async throws {

        guard try await dropBoxManager.getMetaData_MMP(type: type) else {
            Logger.debug_MMP("Category already getted")
            return
        }

        let json = try await dropBoxManager.downloadData_MMP(filePath: type.downloadPath).json()
        let categories = try getObjectsFromArrayDict(json: json, type: type)
        await saveModels(type: type, data: categories)

        Logger.debug_MMP("Category get success")

    }

    func getEditor_MMP(type: ContentType_MMP = .editor) async throws {

        guard try await dropBoxManager.getMetaData_MMP(type: type) else {
            Logger.debug_MMP("Editor already getted")
            return
        }

        let json = try await dropBoxManager.downloadData_MMP(filePath: type.downloadPath).json()
        let editors = try getObjectsFromDict(json: json, type: type)
        await saveModels(type: type, data: editors)

        Logger.debug_MMP("Editor get success")

    }

    func getItems_MMP(type: ContentType_MMP = .items) async throws {

        guard try await dropBoxManager.getMetaData_MMP(type: type) else {
            Logger.debug_MMP("Items already getted")
            return
        }

        let json = try await dropBoxManager.downloadData_MMP(filePath: type.downloadPath).json()
        let items = try getObjectsFromArrayDict(json: json, type: type)
        await saveModels(type: type, data: items)

        Logger.debug_MMP("Items get success")
    }

    func getSkins_MMP(type: ContentType_MMP = .skins) async throws {

        guard try await dropBoxManager.getMetaData_MMP(type: type) else {
            Logger.debug_MMP("Items already getted")
            return
        }

        let json = try await dropBoxManager.downloadData_MMP(filePath: type.downloadPath).json()
        let skins = try getObjectsFromArrayDict(json: json, type: type)
        await saveModels(type: type, data: skins)

        Logger.debug_MMP("Skins get success")
    }
}

// MARK: - CoreData methods
extension HomeDataAPI_MMP {

//    func updateFavourite_MMP(menu: MenuItem_MMP, data: LocalData) async {
//        if data.isFavourite {
//            await saveFavourite_MMP(menu: menu, data: data)
//        } else {
//            await deleteFavourite_MMP(menu: menu, data: data)
//        }
//    }
//
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
            }
            self.coreDataStore.saveChanges_MMP()
            Logger.debug_MMP("\(type) wtire to CoreData success")
        }
    }
//
//
//    private func deleteFavourite_MMP(menu: MenuItem_MMP, data: LocalData) async {
//        await coreDataStore.viewContext.perform {
//            guard let dataMO = self.coreDataStore.fetch_MMP(request: .favouriteIfExist(with: data.uidMMP, menu: menu))?.first else {
//                return
//            }
//            self.coreDataStore.MMP_deleteObject_MMP(object: dataMO)
//            self.coreDataStore.saveChanges_MMP()
//            Logger.debug_MMP("Delete favourite success")
//        }
//    }
}

// MARK: - Extension
extension HomeDataAPI_MMP {
//    private func modifyArray_MMP(_ array1: inout [LocalData], with array2: [LocalDataMO]) {
//        for (index, element) in array1.enumerated() {
//            if array2.contains(where: { $0.uidMMP == element.uidMMP }) {
//                // Змінюємо значення в першому масиві (array1)
//                array1[index].isFavourite = true
//            }
//        }
//    }
}
