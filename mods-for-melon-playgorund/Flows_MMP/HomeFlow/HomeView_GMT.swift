//
//  HomeView_GMT.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//  
//

import SwiftUI

// MARK: - HomeView

struct HomeView_MMP: View {

    // MARK: - Wrapped Properties

    @FetchRequest<CategoriesMO>(fetchRequest: .categories())
    private var categoriesMO

    @State private var selectedCategories: CategoriesMO?

    @State private var menus: [ContentType_MMP] = ContentType_MMP.home
    @State private var selectedMenu: ContentType_MMP = .mods
    @State private var searchText: String = ""


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

                DynamicFetchView(fetchRequest: .mods(category: selectedCategories?.title ?? "")) { mods in
                    gridView(data: mods)
                }
            }
            .animation(.default, value: selectedMenu)
        }
        .onViewDidLoad(action: {
            selectedCategories = categoriesMO[0]
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
        }
    }
}

// MARK: - Previews

#Preview {
    HomeView_MMP()
}

import CoreData

struct DynamicFetchView<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>

    let content: (FetchedResults<T>) -> Content

    init(fetchRequest: NSFetchRequest<T>, content: @escaping (FetchedResults<T>) -> Content) {
        _fetchRequest = FetchRequest<T>(fetchRequest: fetchRequest)
        self.content = content
    }

    var body: some View {
        content(fetchRequest)
    }
}
