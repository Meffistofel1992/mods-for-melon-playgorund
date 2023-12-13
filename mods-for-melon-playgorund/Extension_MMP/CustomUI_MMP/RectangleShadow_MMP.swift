//
//  View+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

struct ShadowConfig_MMP {
    var shadowColor: Color = .black.opacity(0.25)
    var shadowRadius: CGFloat = 2
    var offSet: (x: CGFloat, y: CGFloat) = (0, isIPad ? 6 : 3)

    static var clear: ShadowConfig_MMP {
        return ShadowConfig_MMP(shadowColor: .clear, shadowRadius: 0)
    }
}

struct RectangleShadow_MMP: ViewModifier {
    let model: ShadowConfig_MMP

    func body(content: Content) -> some View {
        content
            .compositingGroup()
            .shadow(
                color: model.shadowColor,
                radius: model.shadowRadius,
                x: model.offSet.x,
                y: model.offSet.y
            )
    }
}

extension MMP_View {
    func addShadowToRectangle_mmp(model: ShadowConfig_MMP = .init()) -> some View {
        modifier(RectangleShadow_MMP(model: model))
    }
}
