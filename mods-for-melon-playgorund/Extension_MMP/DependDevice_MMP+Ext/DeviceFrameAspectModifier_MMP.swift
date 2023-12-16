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
        isiOsAspec: Bool = false,
        iPadWidth: CGFloat? = nil,
        iPadHeight: CGFloat? = nil,
        isiPadAspec: Bool = true
    ) -> some View {
        modifier(DeviceFrameAspectModifier_MMP(
            iOSWidth: iOSWidth,
            iOSHeight: iOSHeight,
            iPadWidth: iPadWidth,
            iPadHeight: iPadHeight,
            isiPadAspec: isiPadAspec,
            isiOsAspec: isiOsAspec
        ))
    }
}

struct DeviceFrameAspectModifier_MMP: ViewModifier {
    var iOSWidth: CGFloat?
    var iOSHeight: CGFloat?
    var iPadWidth: CGFloat?
    var iPadHeight: CGFloat?
    let isiPadAspec: Bool
    let isiOsAspec: Bool

    let iPadSize: CGSize = .init(width: 1024, height: 1366)
    let iPhoneSize: CGSize = .init(width: 390, height: 844)

    var width_MMP: CGFloat? {
        if idiom == .pad {
            if let iPadWidth  {
                if isiPadAspec {
                    return Utilities_MMP.shared.widthWithOpt_MMP(aspectRatio: iPadWidth / iPadSize.width)
                } else {
                    return iPadWidth
                }

            } else {
                return nil
            }

        } else {
            if let iOSWidth {
                if isiOsAspec {
                    return Utilities_MMP.shared.widthWithOpt_MMP(aspectRatio: iOSWidth / iPhoneSize.width)
                } else {
                    return iOSWidth
                }
            } else {
                return nil
            }
        }
    }

    var height_MMP: CGFloat? {
        if idiom == .pad {
            if let iPadHeight {
                if isiPadAspec {
                    return Utilities_MMP.shared.heightWithOpt_MMP(aspectRatio: iPadHeight / iPadSize.height)
                } else {
                    return iPadHeight
                }
            } else {
                return nil
            }

        } else {
            if let iOSHeight {
                if isiOsAspec {
                    return Utilities_MMP.shared.heightWithOpt_MMP(aspectRatio: iOSHeight / iPhoneSize.height)
                } else {
                    return iOSHeight
                }
            } else {
                return nil
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .frame(
                width: width_MMP,
                height: height_MMP
            )
    }
}
