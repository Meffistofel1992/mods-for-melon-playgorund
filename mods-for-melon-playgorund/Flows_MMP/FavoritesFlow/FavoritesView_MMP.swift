//
//  FavoritesView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 16.12.2023.
//

import SwiftUI
import Resolver

// MARK: - HomeView

struct FavoritesView_MMP: View {

    // MARK: - Wrapped Properties

    @Injected private var coreDataStore: CoreDataStore_MMP

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
                contentList
            }
            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
            .blur(radius: filterIsShowing ? 5 : 0)
        }
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
                predicate: favoritePredicate,
                sortDescriptors: [NSSortDescriptor(keyPath: \ParentMO.title, ascending: true)],
                isFavourite: true
            )
        case .items:
            HomeListView_MMP<ItemsMO>(
                contentType: .items,
                predicate: favoritePredicate,
                sortDescriptors: [NSSortDescriptor(keyPath: \ParentMO.title, ascending: true)],
                isFavourite: true
            )
        case .skins:
            SkinsListView_MMP<SkinsMO>(
                contentType: .skins,
                predicate: favoritePredicate,
                sortDescriptors: [NSSortDescriptor(keyPath: \ParentMO.title, ascending: true)],
                isFavourite: true
            )
        default: EmptyView()
        }
    }
}

// MARK: - Mods View
private extension FavoritesView_MMP {
    var categoriesView: some View {
        HStack(spacing: isIPad ? 24 : 12) {
            ForEach(menus) { menu in
                SectionButton(selectedType: $selectedMenu, type: menu)
            }
        }
    }
}

// MARK: - Previews`

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return FavoritesView_MMP()
        .environment(\.managedObjectContext, moc)
}
