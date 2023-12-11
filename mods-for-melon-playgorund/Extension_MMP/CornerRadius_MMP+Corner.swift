//
//  CornerRadius+Corner.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

typealias MMP_View = View

// Rounded Corner
extension MMP_View {
    func MMP_cornerRadius_MMP(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner_MMP(radius: radius, corners: corners) )
    }
}

struct RoundedCorner_MMP: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
}
