//
//  DeviceFontModifier.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 22.11.2023.
//

import SwiftUI

extension MMP_View {
    func iosDeviceTypeFont_mmp(
        iOS: FontModel_MMP,
        iPad: FontModel_MMP
    ) -> some View {
        modifier(DeviceFontModifier_MMP(
            iPhonefont: iOS,
            iPadFont: iPad
        ))
    }
}

struct DeviceFontModifier_MMP: ViewModifier {
    let iPhonefont: FontModel_MMP
    let iPadFont: FontModel_MMP

    var font_MMP: FontModel_MMP {
        idiom == .pad ? iPadFont : iPhonefont
    }

    func body(content: Content) -> some View {
        let compoundName_MMP = "\(font_MMP.name.rawValue)\(font_MMP.style.rawValue)"

        return content
            .font(.custom(compoundName_MMP, size: font_MMP.size))
    }
}
