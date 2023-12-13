//
//  ScrollViewFitContent.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//

import SwiftUI

struct ScrollViewFitContent<Content: View>: View {

    @State private var scrollViewContentSize: CGSize = .zero

    let content: BuilderClosure_MMP<Content>

    var body: some View {
        ScrollView(.horizontal) {
            content()
                .background(
                    GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            scrollViewContentSize = geo.size
                        }
                        return Color.clear
                    }
                )
        }
        .frame(
//            maxWidth: scrollViewContentSize.width,
            maxHeight: scrollViewContentSize.height
        )
    }
}
