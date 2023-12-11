//
//  DevicePaddingModifier.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 22.11.2023.
//

import SwiftUI

var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
var isIPad: Bool { idiom == .pad }

extension MMP_View {
    func iosDeviceTypePadding_MMP(
        edge: Edge.Set,
        iOSPadding: CGFloat,
        iPadPadding: CGFloat,
        iPadIsAspect: Bool = false
    ) -> some View {
        modifier(DevicePadddingModifier_MMP(
            edge: edge,
            iOSPadding: iOSPadding,
            iPadPadding: iPadPadding,
            iPadIsAspect: iPadIsAspect
        ))
    }
}

struct DevicePadddingModifier_MMP: ViewModifier {
    let edge: Edge.Set
    let iOSPadding: CGFloat
    let iPadPadding: CGFloat
    let iPadIsAspect: Bool

    var iPadPadding_MMP: CGFloat {
        iPadIsAspect ?  Utilities_MMP.shared.widthAspectRatioDevice_MMP(width: iPadPadding) : iPadPadding
    }

    var padding_MMP: CGFloat {
        idiom == .pad ? iPadPadding_MMP : iOSPadding
    }

    func body(content: Content) -> some View {
        content
            .padding(edge, padding_MMP)
    }
}
