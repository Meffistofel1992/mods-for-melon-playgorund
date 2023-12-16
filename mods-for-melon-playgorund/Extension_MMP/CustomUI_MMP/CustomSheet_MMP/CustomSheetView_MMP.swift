//
//  CustomSheetView.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 17.11.2023.
//

import SwiftUI

struct CustomSheetView_MMP {
    static func loading_MMP() -> some View {
        LargeButton_MMP(
            text: "Downloading",
            borderColor: .cE9E9E9,
            fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 38 : 19),
            backgroundColor: .blackOpacity,
            foregroundColor: .white,
            height: isIPad ? 72 : 50,
            lineWidth: 1
        )
        .iosDeviceTypeFrameAspec_mmp(iOSWidth: 208, isiOsAspec: true, iPadWidth: 416, isiPadAspec: true)
        .disabled(true)
    }

    static func loaded_MMP() -> some View {
        LargeButton_MMP(
            text: "Downloaded",
            borderColor: .cE9E9E9,
            fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 38 : 19),
            backgroundColor: .blackOpacity,
            foregroundColor: .white,
            height: isIPad ? 72 : 50,
            lineWidth: 1
        )
        .iosDeviceTypeFrameAspec_mmp(iOSWidth: 208, isiOsAspec: true, iPadWidth: 416, isiPadAspec: true)
        .disabled(true)
    }

    static func removeFavourite_MMP(
        contentType: ContentType_MMP,
        firstAction: EmptyClosure_MMP? = nil,
        secondAction: EmptyClosure_MMP? = nil
    ) -> some View {
        VStack(spacing: 0) {
            Text("MELON")
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .black, size: 28),
                    iPad: .init(name: .sfProDisplay, style: .black, size: 56)
                )
                .foregroundColor(.white)
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 12, iPadPadding: 24)
            Text("Do you want to remove a \(contentType.rawValue.lowercased()) from your favorites?")
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .medium, size: 20),
                    iPad: .init(name: .sfProDisplay, style: .medium, size: 40)
                )
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)

            HStack(spacing: isIPad ? 48 : 24) {
                LargeButton_MMP(
                    text: "Cancel",
                    borderColor: .cE9E9E9,
                    fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 40 : 19),
                    backgroundColor: .blackOpacity,
                    foregroundColor: .white,
                    height: isIPad ? 72 : 50,
                    lineWidth: 1,
                    action: {
                        firstAction?()
                    }
                )
                LargeButton_MMP(
                    text: "Remove",
                    fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 40 : 19),
                    height: isIPad ? 72 : 50,
                    lineWidth: 3,
                    action: {
                        secondAction?()
                    }
                )
            }
        }
        .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 16, iPadPadding: 32)
        .addRoundedModifier_MMP(radius: 12)
    }

    static func removeMods_MMP(
        title: String,
        firstAction: EmptyClosure_MMP? = nil,
        secondAction: EmptyClosure_MMP? = nil
    ) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .black, size: 28),
                    iPad: .init(name: .sfProDisplay, style: .black, size: 56)
                )
                .foregroundColor(.white)
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 12, iPadPadding: 24)
            Text("Are you sure to delete this mode?")
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .medium, size: 20),
                    iPad: .init(name: .sfProDisplay, style: .medium, size: 40)
                )
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)

            HStack(spacing: isIPad ? 48 : 24) {
                LargeButton_MMP(
                    text: "Cancel",
                    borderColor: .cE9E9E9,
                    fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 40 : 19),
                    backgroundColor: .blackOpacity,
                    foregroundColor: .white,
                    height: isIPad ? 72 : 50,
                    lineWidth: 1,
                    action: {
                        firstAction?()
                    }
                )
                LargeButton_MMP(
                    text: "Mods",
                    fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 40 : 19),
                    height: isIPad ? 72 : 50,
                    lineWidth: 3,
                    action: {
                        secondAction?()
                    }
                )
            }
        }
        .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 16, iPadPadding: 32)
        .addRoundedModifier_MMP(radius: 12)
        .frame(maxWidth: 700)
    }
}

#Preview {
    CustomSheetView_MMP.removeMods_MMP(title: "TMBP T15 ARMATA")
        .preferredColorScheme(.dark)
}
