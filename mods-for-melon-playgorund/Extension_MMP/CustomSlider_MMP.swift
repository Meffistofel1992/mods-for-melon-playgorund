//
//  CustomSlider_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 18.12.2023.
//

import SwiftUI

struct CustomSlider: View {

    @Binding var sliderValue: Double

    let maxValue: CGFloat

    private let totalWidth = UIScreen.main.bounds.width - (isIPad ? 79 : 39)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading ){
                Rectangle()
                    .fill(Color.cECF0FF)
                    .frame(maxWidth: .infinity)
                    .frame(height: 6)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged( { (value) in

                                // update the width only if its greater than zero and less than the total width
                                if value.location.x <= totalWidth && value.location.x >= 0 {
                                    self.sliderValue = (maxValue * value.location.x) / totalWidth
                                }
                            }))

                Rectangle()
                    .fill(.c7636C9)
                    .frame(width: min(CGFloat(sliderValue) / 1000 * geometry.size.width, geometry.size.width), height: 6)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged( { (value) in

                                // update the width only if its greater than zero and less than the total width
                                if value.location.x <= totalWidth && value.location.x >= 0 {
                                    self.sliderValue = (maxValue * value.location.x) / totalWidth
                                }
                            }))

            }
            .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 12))
        }
        .frame(height: 6)
    }
}
