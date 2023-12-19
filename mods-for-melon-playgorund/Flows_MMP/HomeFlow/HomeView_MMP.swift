//
//  HomeView_GMT.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//  
//

import SwiftUI
import Resolver
import FlowStacks

// MARK: - HomeView

class HomeController: ObservableObject {
    @Published var selectedCategories: CategoriesMO?
    @Published var searchText: String = ""

    @Published var menus: [ContentType_MMP] = ContentType_MMP.home
    @Published var selectedMenu: ContentType_MMP = .mods
    @Published var filterIsShowing: Bool = false
    @Published var isAppear: Bool = false
}

struct HomeView_MMP: View {

    // MARK: - Wrapped Properties

    @Injected private var coreDataStore: CoreDataStore_MMP
    @Injected private var homApiManager: HomeDataAPI_MMP
    @Injected private var navigationStore: MainNavigationStore_MMP
    @InjectedObject private var iapManager: IAPManager_MMP
    @InjectedObject private var homeController: HomeController

    @FetchRequest<CategoriesMO>(fetchRequest: .categories())
    private var categoriesMO

    // MARK: - body View

    var body: some View {
        ZStackWithBackground_MMP {
            VStack(spacing: 0) {
                categoriesView
                    .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)

                VStack(spacing: 0) {
                    if homeController.selectedMenu == .mods {
                        searchAndFilerView
                            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
                            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                            .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    }
                }
                .animation(.default, value: homeController.selectedMenu)
                contentList
            }
            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
            .blur(radius: homeController.filterIsShowing ? 5 : 0)
        }
        .onViewDidLoad(action: {
            if !categoriesMO.isEmpty {
                let index = !iapManager.boughtProducts.contains(.otherType) ? 1 : 0
                homeController.selectedCategories = categoriesMO[index]
            }
        })
        .onReceive(iapManager.subscribedSuccess, perform: { type in
            navigationStore.productType = nil

            switch type {
            case .contentType where navigationStore.activeTab == .home:
                homeController.selectedMenu = .skins
            case .otherType:
                homeController.selectedCategories = categoriesMO[0]
            default: break
            }
        })
    }

    @ViewBuilder
    var contentList: some View {
        switch homeController.selectedMenu {
        case .mods:
            HomeListView_MMP<ModsMO>(
                searchText: homeController.searchText,
                contentType: .mods,
                predicate: homePredicate(with: homeController.selectedCategories?.title ?? "", searchText: homeController.searchText),
                sortDescriptors: [NSSortDescriptor(keyPath: \CategoriesMO.title, ascending: true)]
            )
            .task {
                try? await homApiManager.getModels(type: homeController.selectedMenu)
            }
        case .items:
            HomeListView_MMP<ItemsMO>(
                contentType: .items,
                sortDescriptors: [NSSortDescriptor(keyPath: \ParentMO.title, ascending: true)]
            )
            .task {
                try? await homApiManager.getModels(type: homeController.selectedMenu)
            }
        case .skins:
            SkinsListView_MMP<SkinsMO>(
                contentType: .skins,
                sortDescriptors: [NSSortDescriptor(keyPath: \ParentMO.title, ascending: true)]
            )
            .task {
                try? await homApiManager.getModels(type: homeController.selectedMenu)
            }
        default: EmptyView()
        }
    }
}

// MARK: - Mods View
private extension HomeView_MMP {
    var categoriesView: some View {
        HStack(spacing: isIPad ? 24 : 12) {
            let isNeedSub = !iapManager.boughtProducts.contains(.contentType)
            ForEach(homeController.menus) { menu in
                SectionButton(selectedType: $homeController.selectedMenu, type: menu) {
                    if isNeedSub && menu == .skins {
                        navigationStore.productType = .contentType
                        return
                    }
                    if homeController.selectedMenu != menu {
                        homeController.selectedMenu = menu
                    }
                }
                .opacity(isNeedSub && menu == .skins ? 0.5 : 1)
                .overlay(alignment: .topTrailing) {
                    if isNeedSub && menu == .skins {
                        let sizeIPad = Utilities_MMP.shared.heightAspectRatioDevice_MMP(height: 40)

                        Image(.iconLock)
                            .resizable()
                            .iosDeviceTypeFrame_mmp(iOSWidth: 20, iOSHeight: 20, iPadWidth: sizeIPad, iPadHeight: sizeIPad)
                            .iosDeviceTypePadding_MMP(edge: [.top, .trailing], iOSPadding: 3, iPadPadding: 6)
                    }
                }
            }
        }
    }
    var searchAndFilerView: some View {
        HStack(spacing: isIPad ? 24 : 12) {
            SearchTextField_MMP(searchText: $homeController.searchText)

            Button {
                homeController.filterIsShowing.toggle()
            } label: {
                Image(.iconFilter)
                    .resizable()
                    .iosDeviceTypeFrameAspec_mmp(iOSWidth: 24, iOSHeight: 24, iPadWidth: 48, iPadHeight: 48)
            }
            .iosDeviceTypeFrameAspec_mmp(iOSWidth: 48, iOSHeight: 48, iPadWidth: 92, iPadHeight: 92)
            .addRoundedModifier_MMP(radius: isIPad ? 16 : 8)
        }
    }
}

// MARK: - Previews`

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return HomeView_MMP()
        .environment(\.managedObjectContext, moc)
        .environmentObject(IAPManager_MMP())
}
