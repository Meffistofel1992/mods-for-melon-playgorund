//
//  app_MMP+Resolver.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { NetworkMonitoringManager_MMP() }.scope(.application)
        register { CoreDataStore_MMP() }.scope(.application)
        register { MainNavigationStore_MMP() }.scope(.application)
        register { SaverManager_MMP() }.scope(.application)
        register { Dropbox_MMP() }.scope(.application)
        register { HomeDataAPI_MMP() }.scope(.application)
    }
}
