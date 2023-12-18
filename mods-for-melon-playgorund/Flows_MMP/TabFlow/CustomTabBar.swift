//
//  CustomTabBar.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 19.12.2023.
//

import SwiftUI

struct CustomTabBar: View {

    @EnvironmentObject private var iapManager: IAPManager_MMP
    @EnvironmentObject private var navigationStore: MainNavigationStore_MMP

    @Binding var activeTab: Tab

    var tint: Color = .white
    var inactiveTint: Color = Color.c66656A

    var body: some View {
        /// Moving all the Remaining Tab Item's to Bottom
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabItem(
                    activeTab: $activeTab,
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: tab,
                    isNeedLock: !iapManager.boughtProducts.contains(.funcType) && tab == .editor
                ) {
                    if !iapManager.boughtProducts.contains(.funcType), tab == .editor {
                        navigationStore.productType = .funcType
                        return
                    }
                    activeTab = tab
                }
            }
        }
        .iosDeviceTypeFrame_mmp(iOSHeight: 70, iPadHeight: 90)
        .background(content: {
            Color.blackMmp.ignoresSafeArea()
        })
        /// Adding Animation
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
        .if(isIPad, transform: { $0.clipShape(Capsule()) })
        .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 0, iPadPadding: 85, iPadIsAspect: true)
        .onReceive(iapManager.subscribedSuccess, perform: hangleSuccessSub)
    }

    private func hangleSuccessSub(_ sub: ProductType_MMP) {
        navigationStore.productType = nil

        switch sub {
        case .funcType:
            activeTab = .editor
        default: break
        }
    }
}

/// Tab Bar Item
struct TabItem: View {
    @Binding var activeTab: Tab

    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    let isNeedLock: Bool

    var didTapToTab: EmptyClosure_MMP

    /// Each Tab Item Position on the Screen
    @State private var tabPosition: CGPoint = .zero
    var body: some View {
        Group {
            if isIPad {
                HStack {
                    content
                }
            } else {
                VStack(spacing: 5) {
                    content
                }
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            didTapToTab()
        }
    }

    @ViewBuilder
    private var content: some View {
        Image(tab.image)
            .foregroundColor(activeTab == tab ? tint : inactiveTint)
            /// Increasing Size for the Active Tab
            .frame(width: 24, height: 24)
            .overlay(alignment: .topTrailing) {
                if isNeedLock {
                    Image(.iconLock)
                        .offset(x: 17, y: -7)
                }
            }

        Text(tab.rawValue)
            .font(.fontWithName_MMP(.sfProDisplay, style: activeTab == tab ? .bold : .regular, size: isIPad ? 16 : 12))
            .foregroundColor(activeTab == tab ? tint : inactiveTint)
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


#Preview {
    CustomTabBar(activeTab: .constant(.home))
}