//
//  RoundedRectangle.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//

import SwiftUI

struct RoundedRectangleModifier_MMP: ViewModifier {
    let radius: CGFloat
    let bgColor: Color
    let strokeBorder: Color
    let lineWidth: CGFloat
    let isNeeedShadow: Bool

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: radius)
                    .customfill_MMP(
                        bgColor,
                        strokeBorder: strokeBorder,
                        lineWidth: lineWidth
                    )
                    .addShadowToRectangle_mmp(model: isNeeedShadow ? .init() : .clear)
            }
    }
}

extension View {
    func addRoundedModifier_MMP(
        radius: CGFloat,
        bgColor: Color = .blackOpacity,
        strokeBorder: Color = .cE9E9E9,
        lineWidth: CGFloat = isIPad ? 2 : 1,
        isNeeedShadow: Bool = true
    ) -> some View {
        modifier(
            RoundedRectangleModifier_MMP(
                radius: radius,
                bgColor: bgColor,
                strokeBorder: strokeBorder,
                lineWidth: lineWidth,
                isNeeedShadow: isNeeedShadow
            )
        )
    }
}
