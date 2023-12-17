//
//  EditorColider_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

struct EditorColider_MMP: View {

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
            HStack(spacing: 0) {
                coliderVStack(title: "Living:", textX: $editorController_MMP.myMod.xValue, textY: $editorController_MMP.myMod.yValue)
                Spacer()
                coliderVStack(title: "Metal:", textX: $editorController_MMP.myMod.heightValue, textY: $editorController_MMP.myMod.widthValue)
            }
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 12, iPadPadding: 24)
            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 40)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
        }
        .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 16, iPadPadding: 32)
    }
}

// MARK: - Set Colider
private extension EditorColider_MMP {
    func coliderVStack(title: String, textX: Binding<String?>, textY: Binding<String?>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundStyle(Color.white)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .bold, size: 16),
                    iPad: .init(name: .sfProDisplay, style: .bold, size: 32)
                )
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 12, iPadPadding: 24)
            dataHStack(title: "X:", text: textX)
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 14, iPadPadding: 28)
            dataHStack(title: "Y:", text: textY)

        }
    }

    func dataHStack(title: String, text: Binding<String?>) -> some View {
        HStack(spacing: isIPad ? 12 : 6) {
            Text(title)
                .foregroundStyle(.white)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .medium, size: 16),
                    iPad: .init(name: .sfProDisplay, style: .medium, size: 32)
                )
            TextField(text: text ?? "", prompt: Text("Input")) {

            }
            .tint(.white)
            .multilineTextAlignment(.center)
            .iosDeviceTypeFont_mmp(
                iOS: .init(name: .sfProDisplay, style: .medium, size: 16),
                iPad: .init(name: .sfProDisplay, style: .medium, size: 32)
            )
            .iosDeviceTypeFrame_mmp(iOSWidth: 106, iOSHeight: 38, iPadWidth: 212, iPadHeight: 76)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
        }
    }
}

#Preview {
    EditorColider_MMP()
}
