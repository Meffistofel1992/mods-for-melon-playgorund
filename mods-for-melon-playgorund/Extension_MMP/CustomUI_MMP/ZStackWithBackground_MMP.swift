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
                stops: [
                    Gradient.Stop(color: Color(red: 0.57, green: 0.32, blue: 0.89), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.16, green: 0, blue: 0.36), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .ignoresSafeArea()
            content
        }
    }
}
