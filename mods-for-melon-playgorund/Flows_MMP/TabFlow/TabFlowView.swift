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

    @InjectedObject private var homeController: HomeController
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
        .fullScreenCover(item: $navigationStore.productType) { item in
            SubscriptionView(SubViewModel_MMP: SubViewModel_MMP(productType: item))
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar()
        }
        .overlay(alignment: .bottom) {
            VStack {
                if homeController.filterIsShowing {
                    BottomSheetView_MMP(
                        isShowing: $homeController.filterIsShowing,
                        isAppear: $homeController.isAppear,
                        content: FilterView_MMP(
                            selectedCategories: $homeController.selectedCategories,
                            filterIsShowing: $homeController.filterIsShowing,
                            isAppear: $homeController.isAppear
                        )
                    )
                }
            }
            .animation(.default, value: homeController.filterIsShowing)
        }

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
        .environmentObject(IAPManager_MMP())
}
