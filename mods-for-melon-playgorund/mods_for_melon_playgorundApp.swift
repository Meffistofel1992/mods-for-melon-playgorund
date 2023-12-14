//
//  mods_for_melon_playgorundApp.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import SwiftUI
import Resolver

@main
struct mods_for_melon_playgorundApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @Injected private var dropBox: Dropbox_MMP
    @Injected private var coreDataStore: CoreDataStore_MMP

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { basicSetup() }
                .environment(\.managedObjectContext, coreDataStore.viewContext)
        }
    }

    private func basicSetup() {
        UIApplication.shared.addTapGestureRecognizer()
        dropBox.initDropBox_MMP()

        UIButton.appearance().isMultipleTouchEnabled = false
        UIButton.appearance().isExclusiveTouch = true
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true

        UIRefreshControl.appearance().tintColor = UIColor.black

//        UIFont.familyNames.forEach({ familyName in
//                    let fontNames = UIFont.fontNames(forFamilyName: familyName)
//                    print(familyName, fontNames)
//                })
    }
}
