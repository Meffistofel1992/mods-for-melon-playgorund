//
//  TabView_MMP+Appearance.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 12.12.2023.
//

import SwiftUI

struct TabBarAppearance_MMP: ViewModifier {

    init(backgroundColor: UIColor) {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        tabBarAppearance.backgroundColor = backgroundColor

//        updateTabBarItemAppearance_mmp(appearance: tabBarAppearance.compactInlineLayoutAppearance)
//        updateTabBarItemAppearance_mmp(appearance: tabBarAppearance.inlineLayoutAppearance)
//        updateTabBarItemAppearance_mmp(appearance: tabBarAppearance.stackedLayoutAppearance)

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    func body(content: Content) -> some View {
        content
    }

    private func updateTabBarAppearance() {

    }

    @available(iOS 13.0, *)
    private func updateTabBarItemAppearance_mmp(appearance: UITabBarItemAppearance) {
        let tintColor: UIColor = UIColor(named: "c0983FE")!
        let unselectedItemTintColor: UIColor = UIColor(named: "c999999")!

        appearance.selected.iconColor = tintColor
        appearance.normal.iconColor = unselectedItemTintColor
    }

}

extension View {
    func tabBarAppearance_mmp(backgroundColor: UIColor = .white) -> some View {
        modifier(TabBarAppearance_MMP(backgroundColor: backgroundColor))
    }
}
