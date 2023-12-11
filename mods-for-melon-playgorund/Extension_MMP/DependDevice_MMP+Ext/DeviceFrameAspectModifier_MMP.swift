//
//  DeviceFrameModifier.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 22.11.2023.
//

import SwiftUI

extension MMP_View {
    func iosDeviceTypeFrameAspec_mmp(
        iOSWidth: CGFloat? = nil,
        iOSHeight: CGFloat? = nil,
        iPadWidth: CGFloat? = nil,
        iPadHeight: CGFloat? = nil
    ) -> some View {
        modifier(DeviceFrameAspectModifier_MMP(
            iOSWidth: iOSWidth,
            iOSHeight: iOSHeight,
            iPadWidth: iPadWidth,
            iPadHeight: iPadHeight
        ))
    }
}

struct DeviceFrameAspectModifier_MMP: ViewModifier {
    var iOSWidth: CGFloat?
    var iOSHeight: CGFloat?
    var iPadWidth: CGFloat?
    var iPadHeight: CGFloat?

    let iPadSize: CGSize = .init(width: 1024, height: 1366)
    let iPhoneSize: CGSize = .init(width: 390, height: 844)

    var widthRatio_mmp: CGFloat? {
        if idiom == .pad {
            if let iPadWidth {
                return iPadWidth / iPadSize.width
            } else {
                return nil
            }

        } else {
            if let iOSWidth {
                return iOSWidth / iPhoneSize.width
            } else {
                return nil
            }
        }
    }

    var heightRatio_mmp: CGFloat? {
        if idiom == .pad {
            if let iPadHeight {
                return iPadHeight / iPadSize.height
            } else {
                return nil
            }

        } else {
            if let iOSHeight {
                return iOSHeight / iPhoneSize.height
            } else {
                return nil
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .frame(
                width: Utilities_MMP.shared.widthWithOpt_MMP(aspectRatio: widthRatio_mmp),
                height: Utilities_MMP.shared.heightWithOpt_MMP(aspectRatio: heightRatio_mmp)
            )
    }
}
