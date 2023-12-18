//
//  HomeDetailCardView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 18.12.2023.
//

import SwiftUI

struct HomeDetailCardView_MMP: View {

    @ObservedObject var item: ParentMO
    @Binding  var imageData: Data?

    let contentType: ContentType_MMP

    var didTapDownload: AsyncEmptyClosure_MMP

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                AsyncLoadingImage_MMP(
                    path: "\(contentType.folderName)/\(item.imagePathOrEmpty)",
                    size: .init(
                        width: .zero,
                        height: imageHeight
                    ),
                    isNeedFit: contentType == .skins,
                    imageDidLoad: { self.imageData = $0 }
                )
                .clipShape(RoundedRectangle(cornerRadius: isIPad ? 16 : 8))
                .frame(maxWidth: .infinity)
                .if(contentType != .mods, transform: {
                    $0.iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 20, iPadPadding: 20)
                })
                .background {
                    RoundedRectangle(cornerRadius: isIPad ? 16 : 8)
                        .fill(Color.white)
                }

                VStack(alignment: .leading, spacing: 0) {
                    if contentType == .mods {
                        Text("Mod Description")
                            .iosDeviceTypeFont_mmp(
                                iOS: .init(name: .sfProDisplay, style: .black, size: 20),
                                iPad: .init(name: .sfProDisplay, style: .black, size: 40)
                            )
                            .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 8, iPadPadding: 16)
                    }

                    Text(item.titleOrEmpty)
                        .iosDeviceTypeFont_mmp(
                            iOS: titleFont.ios,
                            iPad: titleFont.iPad
                        )
                        .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)

                    if contentType != .skins {
                        Text(item.descriptionOrEmpty)
                            .iosDeviceTypeFont_mmp(
                                iOS: .init(name: .sfProDisplay, style: .medium, size: 16),
                                iPad: .init(name: .sfProDisplay, style: .medium, size: 32)
                            )
                            .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)
                    }
                    if contentType != .skins {
                        LargeButton_MMP(
                            text: "Download",
                            isValid: !item.isLoadedToPhone,
                            lineWidth: 3,
                            asyncAction: {
                                await didTapDownload()
                            }
                        )
                        .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)
                    }
                }
                .foregroundStyle(.white)
                .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)

            }
            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 40)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 20, iPadPadding: 40)
        }
    }
}

// MARK: - computed property
private extension HomeDetailCardView_MMP {
    var imageHeight: CGFloat {
        switch contentType {
        case .mods:
            return Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 320/1024 : 160/390)
        case .skins:
            return Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 540/1024 : 270/390)
        case .items:
            return Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 540/1024 : 270/390)
        default:
            return .zero
        }
    }

    var titleFont: (ios: FontModel_MMP, iPad: FontModel_MMP) {
        if contentType == .items || contentType == .skins {
            return (
                .init(name: .sfProDisplay, style: .black, size: 20),
                .init(name: .sfProDisplay, style: .black, size: 40)
            )
        } else {
            return (
                .init(name: .sfProDisplay, style: .bold, size: 16),
                .init(name: .sfProDisplay, style: .bold, size: 32)
            )
        }
    }
}
