//
//  Font_MMP+Ext.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import SwiftUI

extension UIFont {
    enum Style_MMP: String {
        case black = "-Black"
        case bold = "-Bold"
        case demiBold = "-Demibold"
        case demiBoldItalic = "-DemiboldItalic"
        case heavy = "-Heavy"
        case heavyItalic = "-HeavyItalic"
        case medium = "-Medium"
        case mediumItalic = "-MediumItalic"
        case ultraLight = "-Ultralight"
        case ultraLightItalic = "-UltralightItalic"
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-Semibold"
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case roman = "-Roman"
        case italic = "-Italic"
        case extraBold = "-Extrabold"
        case boldItalic = "-BoldItalic"
        case normal = "-Normal"
        case regular = "-Regular"
        case none = ""
    }

    enum Name_MMP: String {
        case gluten = "Gluten"
        case sfProDisplay = "SFProDisplay"
        case inter = "Inter"
        case sfCompactRounded = "SFCompactRounded"
    }

    static func fontWithName_MMP(_ name: Name_MMP, style: Style_MMP, size: CGFloat) -> UIFont {
        let compoundName = "\(name.rawValue)\(style.rawValue)"

        return UIFont(name: compoundName, size: size)!
    }
}

extension Font {
    static func fontWithName_MMP(_ name: UIFont.Name_MMP, style: UIFont.Style_MMP, size: CGFloat) -> Font {
        let compoundName = "\(name.rawValue)\(style.rawValue)"
        return .custom(compoundName, size: size)
    }
}


struct FontModel_MMP {
    let name: UIFont.Name_MMP
    let style: UIFont.Style_MMP
    let size: CGFloat
}
