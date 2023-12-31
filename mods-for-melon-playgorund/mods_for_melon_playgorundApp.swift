//
//  mods_for_melon_playgorundApp.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import SwiftUI

@main
struct mods_for_melon_playgorundApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
