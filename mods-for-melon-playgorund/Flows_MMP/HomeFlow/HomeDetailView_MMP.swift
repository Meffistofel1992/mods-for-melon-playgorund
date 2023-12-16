//
//  ModDetailView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 15.12.2023.
//

import SwiftUI
import FlowStacks
import Resolver

struct HomeDetailView_MMP: View {

    @Environment(\.createSheet_mmp) private var createSheet_mmp
    @EnvironmentObject private var navigator: FlowNavigator<MainRoute_MMP>
    @Injected private var saveManager: SaverManager_MMP
    @Injected private var networkManager: NetworkMonitoringManager_MMP
    @Injected private var coreDataStore: CoreDataStore_MMP

    @ObservedObject var item: ParentMO

    let contentType: ContentType_MMP

    private var path: String {
        "\(contentType.folderName)/\(item.downloadPathOrEmpty)"
    }

    var body: some View {
        ZStackWithBackground_MMP {
            VStack(spacing: 0) {
                header
                card
                Spacer(minLength: 0)
            }
            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
            .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: Child View
private extension HomeDetailView_MMP {
    var     header: some View {
        HStack(spacing: 0) {
            RectangleButton_MMP(image: .iconBack) {
                navigator.pop()
            }
            Spacer()

            HStack(spacing: isIPad ? 40 : 20) {
                if contentType != .skins {
                    RectangleButton_MMP(image: .iconShare) {
                        didTaspToShare()
                    }
                    .disableWithOpacity_MMP(!saveManager.checkIfFileExistInDirectory_MMP(apkFileName: path))
                }

                if contentType == .mods {
                    RectangleButton_MMP(image: .iconPencil) {
                        didTapToEditor()
                    }
                }
                RectangleButton_MMP(image: favouriteIcon) {
                    didTapToBookmark()
                }
            }
        }
    }

    var card: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                AsyncLoadingImage_MMP(
                    path: "\(contentType.folderName)/\(item.imagePathOrEmpty)",
                    size: .init(
                        width: .zero,
                        height: imageHeight
                    ),
                    isNeedFit: contentType == .skins
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
                    LargeButton_MMP(text: "Download", isValid: !saveManager.checkIfFileExistInDirectory_MMP(apkFileName: path),  lineWidth: 3)
                }
                .foregroundStyle(.white)
                .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)

            }
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 20, iPadPadding: 40)
            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 40)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 20, iPadPadding: 40)
        }
    }

    func download() async {
        guard networkManager.isReachable_MMP else {
            return
        }
        createSheet_mmp?(.init(type: .loading, firstAction: { _ in }, secondAction: {_ in }))
        await saveManager.downloadDidTap(file: (item.imagePathOrEmpty, item.downloadPathOrEmpty))
    }
}

// MARK: - Methods
private extension HomeDetailView_MMP {
    func didTapToBookmark() {
        if item.isFavourite {
            createSheet_mmp?(
                .init(
                    type: .removeFavoutire(contentType),
                    firstAction: { _ in
                        createSheet_mmp?(nil)
                    },
                    secondAction: { _ in
                        item.isFavourite.toggle()
                        coreDataStore.saveChanges_MMP()
                        createSheet_mmp?(nil)
                    }
                )
            )
        } else {
            item.isFavourite.toggle()
            coreDataStore.saveChanges_MMP()
        }
    }

    func didTapToEditor() {

    }

    func didTaspToShare() {

    }
}

// MARK: - computed property
extension HomeDetailView_MMP {
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

    var favouriteIcon: ImageResource {
        item.isFavourite ? .iconBookmarkFill : .iconBookmark
    }
}

#Preview {

    let moc = CoreDataMockService_MMP.preview
    let mod = CoreDataMockService_MMP.createMods(with: moc)[0]

    return HomeDetailView_MMP(item: mod, contentType: .mods)
        .environment(\.managedObjectContext, moc)
}
