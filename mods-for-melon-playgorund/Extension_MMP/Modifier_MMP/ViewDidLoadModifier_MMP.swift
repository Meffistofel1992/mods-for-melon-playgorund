//
//  ViewDidLoadModifier.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 16.11.2023.
//

import SwiftUI

struct ViewDidLoadModifier_MMP: ViewModifier {
    @State private var viewDidLoad = false
    let action: EmptyClosure_MMP?
    let asyncAction: AsyncEmptyClosure_MMP?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    if !action.isNil {
                        action?()
                    } else {
                        Task {
                            await asyncAction?()
                        }
                    }
                }
            }
    }
}

extension MMP_View {
    func onViewDidLoad(
        action: EmptyClosure_MMP? = nil,
        asyncAction: AsyncEmptyClosure_MMP? = nil
    ) -> some View {
        self.modifier(ViewDidLoadModifier_MMP(action: action, asyncAction: asyncAction))
    }
}
