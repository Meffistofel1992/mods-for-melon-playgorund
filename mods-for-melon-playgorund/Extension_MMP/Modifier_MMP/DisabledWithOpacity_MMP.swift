//
//  DisabledWithOpacity.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 16.12.2023.
//

import SwiftUI

struct DisabledCombineWithOpacity_MMP: ViewModifier {

    let disabled: Bool
    let disabledOpacity: CGFloat

    func body(content: Content) -> some View {
         content
            .disabled(disabled)
            .opacity(disabled ? disabledOpacity : 1)
    }
}

extension View {
    func disableWithOpacity_MMP(_ disabled: Bool, disabledOpacity: CGFloat = 0.4) -> some View {
        modifier(DisabledCombineWithOpacity_MMP(disabled: disabled, disabledOpacity: disabledOpacity))
    }
}
