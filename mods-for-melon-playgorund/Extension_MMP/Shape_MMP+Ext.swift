//
//  Shape+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

typealias MMP_Shape = Shape
typealias MMP_InsettableShape = InsettableShape

extension MMP_Shape {
    func customfill_MMP<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill = .blackOpacity,
        strokeBorder strokeStyle: Stroke = .cE9E9E9,
        lineWidth: Double = isIPad ? 2 : 1
    ) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension MMP_InsettableShape {
    func customfill_MMP<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill = .blackOpacity,
        strokeBorder strokeStyle: Stroke = .cE9E9E9,
        lineWidth: Double = isIPad ? 2 : 1
    ) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
