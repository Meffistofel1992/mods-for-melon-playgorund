//
//  SettingsView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 16.12.2023.
//

import SwiftUI

enum AppSettings: Identifiable, CaseIterable {
    var id: Self { self }
    case privacy
    case term

    var title: String {
        switch self {
        case .privacy:
            return "Privacy Policy"
        case .term:
            return "Terms Of Use"
        }
    }
}

struct SettingsView_MMP: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStackWithBackground_MMP {
            VStack(spacing: isIPad ? 40 : 20) {
                ForEach(AppSettings.allCases) { setting in
                    LargeButton_MMP(
                        text: setting.title,
                        fontStyle: .fontWithName_MMP(.sfProDisplay, style: .bold, size: isIPad ? 32 : 16),
                        backgroundColor: .blackOpacity,
                        action: {
                            handleTapTo(setting: setting)
                        },
                        additionalContent: {
                            HStack(spacing: 0) {
                                Text(setting.title)
                                    .iosDeviceTypeFont_mmp(
                                        iOS: .init(name: .sfProDisplay, style: .black, size: 16),
                                        iPad: .init(name: .sfProDisplay, style: .black, size: 32)
                                    )
                                    .foregroundStyle(Color.white)
                                Spacer()
                                Image(.iconBack)
                                    .resizable()
                                    .iosDeviceTypeFrame_mmp(
                                        iOSWidth: 24,
                                        iOSHeight: 24,
                                        iPadWidth: 40,
                                        iPadHeight: 40
                                    )
                                    .rotationEffect(.degrees(180))
                            }
                            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 40)
                        }
                    )
                }

                Spacer()
            }
            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 40, iPadPadding: 80)
            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
        }
    }

    private func handleTapTo(setting: AppSettings) {
        switch setting {
        case .privacy:
            guard let url = URL(string: Configurations_MMP.policyLink) else {
                return
            }
            openURL(url)
        case .term:
            guard let url = URL(string: Configurations_MMP.termsLink) else {
                return
            }
            openURL(url)
        }
    }
}

#Preview {
    SettingsView_MMP()
}
