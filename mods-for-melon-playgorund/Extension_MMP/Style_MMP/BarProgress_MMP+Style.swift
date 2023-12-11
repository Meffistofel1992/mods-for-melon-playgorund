//
//  BarProgress+Style.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 16.11.2023.
//

import SwiftUI

struct BarProgressStyle_MMP: ProgressViewStyle {

//    var stroke: Stroke
    var color: Color = .red
    var bgColor: Color = .white
    var height: Double = 38.0
    var cornerRadius: CGFloat = 34
    var animation: Animation = .easeInOut

    func makeBody(configuration: Configuration) -> some View {
            let fractionCompleted = configuration.fractionCompleted ?? 0

            return VStack {
                ZStack(alignment: .topLeading) {
                    GeometryReader { geo in
                        Rectangle()
                            .fill(color)
                            .frame(maxWidth: geo.size.width * CGFloat(fractionCompleted))
                            .cornerRadius(cornerRadius)
                            .animation(animation, value: fractionCompleted)
                            .padding(5)

                    }
                }
                .frame(height: height)
                .cornerRadius(cornerRadius)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(bgColor)
//                            .stroke(stroke, lineWidth: 2)
                )
            }
        }
}
