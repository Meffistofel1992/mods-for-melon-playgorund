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

    @FetchRequest<CategoriesMO>(fetchRequest: .categories())
    private var categoriesMO

    @State private var selectedCategories: CategoriesMO?

    @State private var menus: [ContentType_MMP] = ContentType_MMP.home
    @State private var selectedMenu: ContentType_MMP = .mods
    @State private var searchText: String = ""
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
                            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 21, iPadPadding: 40)
                            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                            .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    }
                }

                DynamicFetchView(
                    predicate: modsPredicate(with: selectedCategories?.title ?? ""),
                    sortDescriptors: [NSSortDescriptor(keyPath: \CategoriesMO.title, ascending: true)]
                ) { mods in
                    gridView(data: mods)
                }
            }
            .animation(.default, value: selectedMenu)
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
        })
        .onViewDidLoad(action: {
            if !categoriesMO.isEmpty {
                selectedCategories = categoriesMO[0]
            }
        })
    }
}

// MARK: - Child View
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
                    .iosDeviceTypeFrame_mmp(iOSWidth: 24, iOSHeight: 24, iPadWidth: 48, iPadHeight: 48)
            }
            .iosDeviceTypeFrame_mmp(iOSWidth: 48, iOSHeight: 48, iPadWidth: 96, iPadHeight: 96)
            .addRoundedModifier_MMP(radius: isIPad ? 16 : 8)
        }
    }

    func gridView(data: FetchedResults<ModsMO>) -> some View {
        CategoryList_MMP(data: data) { item in
            VStack(spacing: 0) {
                Image(.imageMock)
                    .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 12, iPadPadding: 24)

                Text("TMBP T15 Armata")
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .bold, size: 16),
                        iPad: .init(name: .sfProDisplay, style: .bold, size: 24)
                    )
                    .foregroundStyle(.white)
                    .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 8, iPadPadding: 8)

                Text("For melon playground")
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .regular, size: 12),
                        iPad: .init(name: .sfProDisplay, style: .regular, size: 20)
                    )
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 12, iPadPadding: 24)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12, isNeeedShadow: false)
            .overlay(alignment: .topTrailing) {
                Button {
                    item.isFavourite.toggle()
                    coreDataStore.saveChanges_MMP()
                } label: {
                    Image(item.isFavourite ? .iconBookmarkFill : .iconBookmark)
                        .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 4, iPadPadding: 8)
                        .addRoundedModifier_MMP(radius: 8, isNeeedShadow: false)
                        .iosDeviceTypePadding_MMP(edge: [.top, .trailing], iOSPadding: 7, iPadPadding: 14)
                }
            }
        }
    }
}

// MARK: - Previews`

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return HomeView_MMP()
        .environment(\.managedObjectContext, moc)
}
