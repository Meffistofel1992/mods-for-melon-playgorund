//
//  EditorProperty_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

struct EditorProperty_MMP: View {

    @EnvironmentObject private var editorController_MMP: EditorController_MMP

    var body: some View {
        VStack(spacing: 0) {
            Text("Set file settings:")
                .textCase(.uppercase)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .bold, size: 22),
                    iPad: .init(name: .sfProDisplay, style: .bold, size: 44)
                )
                .foregroundStyle(.white)
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 12, iPadPadding: 24)
            VStack(alignment: .leading, spacing: isIPad ? 40 : 20) {
                propertyHStack(title: "Can be taken:", isActive: $editorController_MMP.myMod.canBeTaken)
                propertyHStack(title: "Can glow:", isActive: $editorController_MMP.myMod.canGlow)
                propertyHStack(title: "Can burn:", isActive: $editorController_MMP.myMod.canBurn)
                propertyHStack(title: "Can float:", isActive: $editorController_MMP.myMod.canFloat)
            }
            .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 20, iPadPadding: 40)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
        }
        .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 16, iPadPadding: 32)
    }
}

// MARK: - Set properties
private extension EditorProperty_MMP {
    func propertyHStack(title: String, isActive: Binding<Bool>) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .medium, size: 16),
                    iPad: .init(name: .sfProDisplay, style: .medium, size: 32)
                )
                .foregroundStyle(.white)
            Spacer()
            LargeButton_MMP(
                text: text(with: isActive.wrappedValue),
                borderColor: borderColor(with: isActive.wrappedValue),
                fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 32 : 16),
                backgroundColor: bgColor(with: isActive.wrappedValue),
                foregroundColor: foregroundColor(with: isActive.wrappedValue),
                height: isIPad ? 80 : 40,
                lineWidth: lineWidth(with: isActive.wrappedValue),
                action: {
                    isActive.wrappedValue.toggle()
                }
            )
            .iosDeviceTypeFrame_mmp(iOSWidth: 120, iPadWidth: 240)
        }

    }
}

private extension EditorProperty_MMP {
    func text(with isActive: Bool) -> String {
        isActive ? "Active" : "Disabled"
    }

    func foregroundColor(with isActive: Bool) -> Color {
        isActive ? .blackMmp : .white
    }

    func bgColor(with isActive: Bool) -> Color {
        isActive ? .white : .blackOpacity
    }

    func borderColor(with isActive: Bool) -> Color {
        isActive ? .lightPurple : .cE9E9E9
    }

    func lineWidth(with isActive: Bool) -> CGFloat {
        isActive ? (isIPad ? 6 : 3) : (isIPad ? 2 : 1)
    }
}

#Preview {
    EditorProperty_MMP()
}
