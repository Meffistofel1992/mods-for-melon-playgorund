//
//  HomeDataAPI_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation
import Resolver

//private let mapsJsonPath       = "\(MenuItem_MMP.maps.path)maps.json"
//private let modsJsonPath       = "\(MenuItem_MMP.mods.path)mods.json"
//private let wallpapersJsonPath = "\(MenuItem_MMP.wallpapers.path)wallpapers.json"
//private let soundsJsonPath     = "\(MenuItem_MMP.sounds.path)sounds.json"
//private let guidesJsonPath     = "\(MenuItem_MMP.guides.path)guides.json"
//private let setsJsonPath       = "\(MenuItem_MMP.sets.path)sets.json"

class HomeDataAPI_MMP {
    @Injected private var dropBoxManager: Dropbox_MMP
    @Injected private var coreDataStore: CoreDataStore_MMP
}

// MARK: - API Methods
extension HomeDataAPI_MMP {

//    @discardableResult
//    func getMaps_MMP() async throws -> [LocalData] {
//
//        let models: EndPointResponse<[MapsModel_MMP]> = try await dropBoxManager.downloadModel_MMP(filePath: mapsJsonPath)
//        Logger.debug_MMP("Maps get success")
//
//        guard let maps = models.data.first else {
//            return []
//        }
//
//        var localData = maps.list.map(LocalData.init)
//
//        let favouriteData = await fetchFavouriteElement_MMP(menu: .maps)
//
//        if !favouriteData.isEmpty {
//            modifyArray_MMP(&localData, with: favouriteData)
//        }
//
//        self.maps = localData
//
//        return localData
//    }
}

// MARK: - CoreData methods
extension HomeDataAPI_MMP {
//    func fetchFavouriteElement_MMP(menu: MenuItem_MMP) async -> [LocalDataMO] {
//        await coreDataStore.viewContext.perform {
//            guard let items = self.coreDataStore.fetch_MMP(request: .getFavouriteItem(with: menu)) else {
//                return []
//            }
//            Logger.debug_MMP("Fetch favourite success")
//            return items
//        }
//    }
//
//    func updateFavourite_MMP(menu: MenuItem_MMP, data: LocalData) async {
//        if data.isFavourite {
//            await saveFavourite_MMP(menu: menu, data: data)
//        } else {
//            await deleteFavourite_MMP(menu: menu, data: data)
//        }
//    }
//
//    private func saveFavourite_MMP(menu: MenuItem_MMP, data: LocalData) async {
//        await coreDataStore.viewContext.perform {
//            let dataMO = LocalDataMO(context: self.coreDataStore.viewContext)
//            dataMO.uidMMP = data.uidMMP
//            dataMO.menu = menu.rawValue
//            self.coreDataStore.saveChanges_MMP()
//            Logger.debug_MMP("Add favourite success")
//        }
//    }
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
