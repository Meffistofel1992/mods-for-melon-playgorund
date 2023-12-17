//
//  EditorHomeView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI
import Resolver

// MARK: - HomeView

struct EditorHomeView_MMP: View {

    // MARK: - Wrapped Properties

    @Injected private var coreDataStore: CoreDataStore_MMP

    @State private var menus: [EditorContentType_MMP] = EditorContentType_MMP.allCases
    @State private var selectedMenu: EditorContentType_MMP = .living

    // MARK: - body View

    var body: some View {
        ZStackWithBackground_MMP {
            VStack(spacing: 0) {
                categoriesView
                    .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                contentList
            }
            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
        }
    }

    @ViewBuilder
    var contentList: some View {
        if selectedMenu != .myWorks {
            EditorListView_MMP<EditorMO>(
                contentType: selectedMenu,
                predicate: editorPredicate(contentType: selectedMenu)
            )
        } else {
            EditorListView_MMP<MyWorks>(contentType: selectedMenu)
        }
    }
}

// MARK: - Mods View
private extension EditorHomeView_MMP {
    var categoriesView: some View {
        HStack(spacing: isIPad ? 24 : 12) {
            ForEach(menus) { menu in
                EditorSectionButton(selectedType: $selectedMenu, type: menu)
            }
        }
    }
}

// MARK: - Previews`

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return EditorHomeView_MMP()
        .environment(\.managedObjectContext, moc)
}
