//
//  TabFlowView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//

import SwiftUI
import FlowStacks
import Resolver

struct TabFlowView: View {

    // MARK: - Wrapped Properties
    @Environment(\.managedObjectContext) private var moc
    @InjectedObject private var navigationStore: MainNavigationStore_MMP

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        Router($navigationStore.routes) { $screen, _ in
            pushContent(with: $screen)
                .hideNavBar(with: true)
        }
    }

    @ViewBuilder
    func pushContent(with path: Binding<MainRoute_MMP>) -> some View {
        switch path.wrappedValue {
        case .tabView:
            tabView
        case let .detailMod(mod, contentType):
            HomeDetailView_MMP(item: mod, contentType: contentType)
        case .editor(let myMod):
            EditorView_MMP(myMod: myMod)
        }
    }

    var tabView: some View {
        TabView(selection: $navigationStore.activeTab) {
            HomeView_MMP()
                .tag(Tab.home)
            EditorHomeView_MMP()
                .tag(Tab.editor)
            FavoritesView_MMP()
                .tag(Tab.favourites)
            SettingsView_MMP()
                .tag(Tab.settings)
        }
        .overlay(alignment: .bottom) {
            CustomTabBar()

        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension MMP_View {
    @ViewBuilder
    func hideNavBar(with isHidden: Bool) -> some View {
        if #available(iOS 16.0, *) {
            self
                .toolbar(.hidden, for: .navigationBar)
        } else {
            self.navigationBarHidden(true)
        }
    }
}


#Preview {
    ContentView()
}
