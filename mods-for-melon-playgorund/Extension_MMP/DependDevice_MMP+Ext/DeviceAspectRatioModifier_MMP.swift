//
//  DeviceAspectRatioModifier.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 27.11.2023.
//

import SwiftUI

extension MMP_View {
    func iosDeviceAspectRatiod_mmp(
        iOS: CGFloat,
        iPad: CGFloat
    ) -> some View {
        modifier(DeviceAspectRatioModifier_MMP(
            iOS: iOS,
            iPad: iPad
        ))
    }
}

struct DeviceAspectRatioModifier_MMP: ViewModifier {
    let iOS: CGFloat
    let iPad: CGFloat

    var aspectRatio_mmp: CGFloat {
        idiom == .pad ? iPad : iOS
    }

    func body(content: Content) -> some View {
        return content
            .aspectRatio(aspectRatio_mmp, contentMode: .fit)
    }
}
