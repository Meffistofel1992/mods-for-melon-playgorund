//
//  SectionButton.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//

import SwiftUI

struct SectionButton: View {

    @Binding var selectedType: ContentType_MMP
    let type: ContentType_MMP

    var body: some View {
        Button {
            if selectedType != type {
                selectedType = type
            }
        } label: {
            Text(type.rawValue)
                .frame(maxWidth: .infinity)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .bold, size: 16),
                    iPad: .init(name: .sfProDisplay, style: .bold, size: 32)
                )
                .foregroundStyle(foregroundColor(type: type))
                .iosDeviceTypeFrame_mmp(iOSHeight: 40, iPadHeight: 80)
                .addRoundedModifier_MMP(
                    radius: isIPad ? 24 : 12,
                    bgColor: bgColor(type: type),
                    strokeBorder: borderColor(type: type),
                    lineWidth: lineWidth(type: type)
                )
        }
    }
}

private extension SectionButton {
    func foregroundColor(type: ContentType_MMP) -> Color {
        selectedType == type ? .blackMmp : .white
    }

    func bgColor(type: ContentType_MMP) -> Color {
        selectedType == type ? .white : .blackOpacity
    }

    func borderColor(type: ContentType_MMP) -> Color {
        selectedType == type ? .lightPurple : .cE9E9E9
    }

    func lineWidth(type: ContentType_MMP) -> CGFloat {
        selectedType == type ? (isIPad ? 6 : 3) : (isIPad ? 2 : 1)
    }
}
