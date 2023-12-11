//
//  Button+Style.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

struct ScaledButtonStyle_MMP: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
