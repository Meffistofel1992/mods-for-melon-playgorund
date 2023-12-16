//
//  RectangleButton_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 15.12.2023.
//

import SwiftUI

struct RectangleButton_MMP: View {

    let image: ImageResource
    var iOsImageSize: CGFloat = 24
    var iOsButtonSize: CGFloat = 38
    var ipaImagedSize: CGFloat = 48
    var ipaButtonSize: CGFloat = 76
    var action: EmptyClosure_MMP

    var body: some View {
        Button {
            action()
        } label: {
            Image(image)
                .resizable()
                .iosDeviceTypeFrameAspec_mmp(
                    iOSWidth: iOsImageSize,
                    iOSHeight: iOsImageSize,
                    iPadWidth: ipaImagedSize,
                    iPadHeight: ipaImagedSize
                )
        }
        .iosDeviceTypeFrameAspec_mmp(
            iOSWidth: iOsButtonSize,
            iOSHeight: iOsButtonSize,
            iPadWidth: ipaButtonSize,
            iPadHeight: ipaButtonSize
        )
        .addRoundedModifier_MMP(radius: isIPad ? 16 : 8)
    }
}
