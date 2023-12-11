//
//  ContentWithSpacer.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

enum SpacerType_MMP {
    case leading
    case trailing
    case bottom
    case top
}

struct ContentWithSpacer_MMP<Content: View>: View {
    let content: Content
    let contentAlignment: SpacerType_MMP
    var spacing: CGFloat?

    init(
        contentAlignment: SpacerType_MMP,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.contentAlignment = contentAlignment
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        if contentAlignment == .bottom {
            VStack {
                Spacer()
                content
            }
        } else if contentAlignment == .top {
            VStack {
                content
                Spacer()
            }
        } else if contentAlignment == .leading {
            HStack {
                content
                Spacer()
            }
        } else {
            HStack {
                Spacer()
                content
            }
        }
    }
}
