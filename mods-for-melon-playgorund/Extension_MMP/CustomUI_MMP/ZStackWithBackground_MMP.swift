//
//  ZStackWithBG.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

struct ZStackWithBackground_MMP<Content: View>: View {
    let alignment: Alignment
    let content: Content

    init(
        alignment: Alignment = .center,
        @ViewBuilder content: BuilderClosure_MMP<Content>
    ) {
        self.alignment = alignment
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: alignment) {
            LinearGradient(
                colors: [
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            content
        }
    }
}
