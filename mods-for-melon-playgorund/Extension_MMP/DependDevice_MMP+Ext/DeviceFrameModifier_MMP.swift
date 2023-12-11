//
//  a.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 27.11.2023.
//

import SwiftUI

extension MMP_View {
    func iosDeviceTypeFrame_mmp(
        iOSWidth: CGFloat? = nil,
        iOSHeight: CGFloat? = nil,
        iPadWidth: CGFloat? = nil,
        iPadHeight: CGFloat? = nil
    ) -> some View {
        modifier(DeviceFrameModifier_MMP(
            iOSWidth: iOSWidth,
            iOSHeight: iOSHeight,
            iPadWidth: iPadWidth,
            iPadHeight: iPadHeight
        ))
    }
}

struct DeviceFrameModifier_MMP: ViewModifier {
    var iOSWidth: CGFloat?
    var iOSHeight: CGFloat?
    var iPadWidth: CGFloat?
    var iPadHeight: CGFloat?

    var size_mmp: (w: CGFloat?, h: CGFloat?) {
        idiom == .pad ? (iPadWidth, iPadHeight) : (iOSWidth, iOSHeight)
    }

    func body(content: Content) -> some View {
        content
            .frame(
                width: size_mmp.w,
                height: size_mmp.h
            )
    }
}
