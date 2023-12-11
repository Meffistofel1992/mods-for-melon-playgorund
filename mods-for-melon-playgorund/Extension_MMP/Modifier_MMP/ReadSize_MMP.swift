//
//  ReadSize.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 23.11.2023.
//

import SwiftUI

struct SizeReaderModifier_MMP: ViewModifier  {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
                Color.clear.onAppear() {
                    DispatchQueue.main.async {
                         size = geometry.size
                    }
                }
            }
        )
    }
}

extension MMP_View {
    func readSize(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeReaderModifier_MMP(size: size))
    }
}
