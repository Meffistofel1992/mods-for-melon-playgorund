//
//  HomeView_GMT.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//  
//

import SwiftUI
import Resolver

// MARK: - HomeView

struct HomeView_MMP: View {

    // MARK: - Wrapped Properties

    @Injected private var coreDataStore: CoreDataStore_MMP
    @Injected private var homApiManager: HomeDataAPI_MMP

    @FetchRequest<CategoriesMO>(fetchRequest: .categories())
    private var categoriesMO

    @State private var selectedCategories: CategoriesMO?
    @State private var searchText: String = ""

    @State private var menus: [ContentType_MMP] = ContentType_MMP.home
    @State private var selectedMenu: ContentType_MMP = .mods
    @State private var filterIsShowing: Bool = false
    @State private var isAppear: Bool = false

    // MARK: - body View

    var body: some View {
        ZStackWithBackground_MMP {
            VStack(spacing: 0) {
                categoriesView
                    .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)

                VStack(spacing: 0) {
                    if selectedMenu == .mods {
                        searchAndFilerView
                            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
                            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                            .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    }
                }
                .animation(.default, value: selectedMenu)
                contentList
            }
            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
            .blur(radius: filterIsShowing ? 5 : 0)
        }
        .presentModelWithUIKit(element: $filterIsShowing,
                               presentationStyle: .overCurrentContext,
                               transitionStyle: .crossDissolve,
                               backgroundColor: .clear,
                               content: {
            BottomSheetView_MMP(
                isShowing: $filterIsShowing,
                isAppear: $isAppear,
                content: FilterView_MMP(
                    selectedCategories: $selectedCategories,
                    filterIsShowing: $filterIsShowing,
                    isAppear: $isAppear
                )
            )
            .environment(\.managedObjectContext, coreDataStore.viewContext)
//            .environment(\.managedObjectContext, CoreDataMockService_MMP.preview)
        })
        .onViewDidLoad(action: {
            if !categoriesMO.isEmpty {
                selectedCategories = categoriesMO[0]
            }
        })
    }

    @ViewBuilder
    var contentList: some View {
        switch selectedMenu {
        case .mods:
            HomeListView_MMP<ModsMO>(
                searchText: searchText,
                contentType: .mods,
                predicate: homePredicate(with: selectedCategories?.title ?? "", searchText: searchText),
                sortDescriptors: [NSSortDescriptor(keyPath: \CategoriesMO.title, ascending: true)]
            )
//            .task {
//                try? await homApiManager.getModels(type: selectedMenu)
//            }
        case .items:
            HomeListView_MMP<ItemsMO>(
                contentType: .items,
                sortDescriptors: [NSSortDescriptor(keyPath: \ParentMO.title, ascending: true)]
            )
//            .task {
//                try? await homApiManager.getModels(type: selectedMenu)
//            }
        case .skins:
            SkinsListView_MMP<SkinsMO>(
                contentType: .skins,
                sortDescriptors: [NSSortDescriptor(keyPath: \ParentMO.title, ascending: true)]
            )
//            .task {
//                try? await homApiManager.getModels(type: selectedMenu)
//            }
        default: EmptyView()
        }
    }
}

// MARK: - Mods View
private extension HomeView_MMP {
    var categoriesView: some View {
        HStack(spacing: isIPad ? 24 : 12) {
            ForEach(menus) { menu in
                SectionButton(selectedType: $selectedMenu, type: menu)
            }
        }
    }
    var searchAndFilerView: some View {
        HStack(spacing: isIPad ? 24 : 12) {
            SearchTextField_MMP(searchText: $searchText)

            Button {
                filterIsShowing.toggle()
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
}
