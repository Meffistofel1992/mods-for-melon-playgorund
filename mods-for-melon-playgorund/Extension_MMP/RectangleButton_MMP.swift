//
//  RectangleButton_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 15.12.2023.
//

import SwiftUI

struct RectangleButton_MMP: View {

    let image: ImageResource
    var action: EmptyClosure_MMP

    var body: some View {
        Button {
            action()
        } label: {
            Image(image)
                .resizable()
                .iosDeviceTypeFrameAspec_mmp(iOSWidth: 24, iOSHeight: 24, iPadWidth: 48, iPadHeight: 48)
        }
        .iosDeviceTypeFrameAspec_mmp(iOSWidth: 38, iOSHeight: 38, iPadWidth: 76, iPadHeight: 76)
        .addRoundedModifier_MMP(radius: isIPad ? 16 : 8)
    }
}
