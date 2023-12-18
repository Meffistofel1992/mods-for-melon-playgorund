//
//  EditorSetTexture_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

struct EditorSetTexture_MMP: View {

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
            uploadView

            CustomSlider(sliderValue: $editorController_MMP.myMod.pixelValue, maxValue: 1000)
                .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 20, iPadPadding: 40)
                .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
                .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 12, iPadPadding: 24)

        }
        .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 16, iPadPadding: 32)
    }
}

// MARK: - Set Texture
private extension EditorSetTexture_MMP {
    var uploadView: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: isIPad ? 14 : 7) {
                Text("PIXEL PER UNIT")
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .regular, size: 16),
                        iPad: .init(name: .sfProDisplay, style: .regular, size: 32)
                    )
                Text(String(Int(editorController_MMP.myMod.pixelValue)))
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .bold, size: 12),
                        iPad: .init(name: .sfProDisplay, style: .bold, size: 24)
                    )
            }
            .foregroundStyle(.white)

            Spacer()

            Button {
                editorController_MMP.imageState = .image
            } label: {
                Text("Upload")
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .mitr, style: .medium, size: 18),
                        iPad: .init(name: .mitr, style: .medium, size: 36)
                    )
                    .foregroundStyle(.white)
                    .iosDeviceTypeFrame_mmp(iOSWidth: 160, iOSHeight: 40, iPadWidth: 320, iPadHeight: 80)
                    .background {
                        RoundedRectangle(cornerRadius: isIPad ? 16 : 8)
                            .fill(Color.c7636C9)
                    }
            }
        }
        .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 20, iPadPadding: 40)
        .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
    }
}

#Preview {
    EditorSetTexture_MMP()
        .environmentObject(EditorController_MMP(myMod: CoreDataMockService_MMP.getMyWorks(with: CoreDataMockService_MMP.preview)[0]))
}
