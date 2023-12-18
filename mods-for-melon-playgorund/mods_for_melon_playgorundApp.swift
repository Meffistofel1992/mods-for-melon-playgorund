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

    @StateObject private var iapManager = IAPManager_MMP()

    @Injected private var dropBox: Dropbox_MMP
    @Injected private var coreDataStore: CoreDataStore_MMP

    private var subViewModel = SubViewModel_MMP(productType: .mainType)
    private let requestManager = RequestManager_MMP.shared

    var body: some Scene {
        WindowGroup {
            VStack {
                if iapManager.isLoadingProducts {
                    Color.black.ignoresSafeArea()
                } else if iapManager.boughtProducts.contains(.mainType) {
                    ContentView()
                        .onAppear { basicSetup() }
                        .environment(\.managedObjectContext, coreDataStore.viewContext)
                        .environmentObject(iapManager)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .identity))
                } else {
                    SubscriptionView(SubViewModel_MMP: subViewModel)
                        .environmentObject(iapManager)
                        .transition(.asymmetric(insertion: .identity, removal: .move(edge: .top)))
                }
            }
            .preferredColorScheme(.dark)
            .task {
                try? await Task.sleep_MMP(seconds: 1)
                requestManager.requestAppTracking_MMP()
            }
            .animation(.easeInOut, value: iapManager.boughtProducts)
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
