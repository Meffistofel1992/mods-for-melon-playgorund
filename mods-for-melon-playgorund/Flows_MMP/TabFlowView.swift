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
    @StateObject private var navigationStore: MainNavigationStore_MMP = .init()

    @State private var activeTab: Tab = .home

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
        }
    }

    var tabView: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                ZStackWithBackground_MMP {
                    HomeView_MMP()
                }
                .tag(Tab.home)
                
                EditorHomeView_MMP()
                    .tag(Tab.editor)
                FavoritesView_MMP()
                    .tag(Tab.favourites)
                SettingsView_MMP()
                    .tag(Tab.settings)
            }

            CustomTabBar()
        }
    }

    @ViewBuilder
    func CustomTabBar(_ tint: Color = .white, _ inactiveTint: Color = Color.c66656A) -> some View {
        /// Moving all the Remaining Tab Item's to Bottom
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    activeTab: $activeTab
                )
            }
        }
        .padding(.vertical, 10)
        .background(content: {
            Color.blackMmp.ignoresSafeArea()
        })
        /// Adding Animation
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

/// Tab Bar Item
struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    @Binding var activeTab: Tab

    /// Each Tab Item Position on the Screen
    @State private var tabPosition: CGPoint = .zero
    var body: some View {
        VStack(spacing: 5) {
            Image(tab.image)
                .foregroundColor(activeTab == tab ? tint : inactiveTint)
                /// Increasing Size for the Active Tab
                .frame(width: 24, height: 24)
                .background {
//                    if activeTab == tab {
//                        Circle()
//                            .fill(tint.gradient)
//                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
//                    }
                }

            Text(tab.rawValue)
                .font(.fontWithName_MMP(.sfProDisplay, style: activeTab == tab ? .bold : .regular, size: 12))
                .foregroundColor(activeTab == tab ? tint : inactiveTint)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            activeTab = tab
        }
    }
}

enum Tab: String, CaseIterable {
    case home = "Home"
    case editor = "Editor"
    case favourites = "Favourites"
    case settings = "Settings"

    var image: ImageResource {
        switch self {
        case .home:
            return .iconHome
        case .editor:
            return .iconEditor
        case .favourites:
            return .iconFavourites
        case .settings:
            return .iconSettings
        }
    }

    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
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
