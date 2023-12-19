//
//  EditorMistTemplates.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

struct EditorMistTemplates_MMP: View {

    @EnvironmentObject private var editorController_MMP: EditorController_MMP

    var body: some View {
        VStack(spacing: isIPad ? 32 : 16) {
            nameTextField
            iconView
            detailTemplatesView
        }
    }
}

// MARK: Misc Templates Views

private extension EditorMistTemplates_MMP {
    var nameTextField: some View {
        HStack(spacing: isIPad ? 32 : 16) {
            Text("Name")
                .foregroundStyle(Color.white)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .medium, size: 16),
                    iPad: .init(name: .sfProDisplay, style: .medium, size: 32)
                )
            TextField(text: $editorController_MMP.myMod.name ?? "", prompt: Text("Input")) {

            }
            .tint(.white)
            .multilineTextAlignment(.trailing)
            .iosDeviceTypeFont_mmp(
                iOS: .init(name: .sfProDisplay, style: .medium, size: 16),
                iPad: .init(name: .sfProDisplay, style: .medium, size: 32)
            )
        }
        .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 40)
        .iosDeviceTypeFrame_mmp(iOSHeight: 44, iPadHeight: 88)
        .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
        .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 16, iPadPadding: 32)
    }

    var iconView: some View {
        VStack(spacing: isIPad ? 40 : 20) {
            HStack(spacing: 0) {
                Text("Load icon:")
                    .foregroundStyle(Color.white)
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .bold, size: 16),
                        iPad: .init(name: .sfProDisplay, style: .bold, size: 32)
                    )
                Spacer()
                LargeButton_MMP(
                    text: "Upload",
                    borderColor: .lightPurple,
                    fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 32 : 16),
                    cornerRadius: isIPad ? 24 : 12,
                    height: isIPad ? 64 : 32,
                    lineWidth: isIPad ? 6 : 3,
                    action: {
                        editorController_MMP.imageState = .icon
                    }
                )
                .iosDeviceTypeFrame_mmp(iOSWidth: 133, iPadWidth: 266)
            }

            let height = Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 192/1024 : 96/390)

            if let image = UIImage(data: editorController_MMP.myMod.iconData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .iosDeviceTypeFrame_mmp(
                        iOSHeight: height,
                        iPadHeight: height
                    )
                    .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 12))
                    .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 15, iPadPadding: 30)
                    .frame(maxWidth: .infinity)
            }
        }
        .iosDeviceTypePadding_MMP(edge: .all , iOSPadding: 20, iPadPadding: 40)
        .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
    }

    var detailTemplatesView: some View {
        VStack(spacing: isIPad ? 40 : 20) {
            detailHStack(label: "Time style:", text: $editorController_MMP.myMod.type)
            detailHStack(label: "Category:", text: $editorController_MMP.myMod.category)
        }
        .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 20, iPadPadding: 40)
        .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
    }

    func detailHStack(label: String, text: Binding<String?>) -> some View {
        HStack(spacing: 0) {
            Text(label)
                .foregroundStyle(Color.white)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .semibold, size: 16),
                    iPad: .init(name: .sfProDisplay, style: .semibold, size: 32)
                )
            Spacer()
            TextField(text: text ?? "", prompt: Text("Input")) {

            }
            .tint(.white)
            .multilineTextAlignment(.center)
            .iosDeviceTypeFont_mmp(
                iOS: .init(name: .sfProDisplay, style: .medium, size: 16),
                iPad: .init(name: .sfProDisplay, style: .medium, size: 32)
            )
            .iosDeviceTypeFrame_mmp(iOSWidth: 166, iOSHeight: 38, iPadWidth: 332, iPadHeight: 76)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
        }
    }
}

#Preview {
    EditorMistTemplates_MMP()
}
