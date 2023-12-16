//
//  FavoritesDetailView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 16.12.2023.
//

import SwiftUI
import FlowStacks
import Resolver

struct FavoritesDetailView_MMP: View {

    @Environment(\.openURL) private var openURL
    @Environment(\.createSheet_mmp) private var createSheet_mmp
    @EnvironmentObject private var navigator: FlowNavigator<MainRoute_MMP>

    @Injected private var saveManager: SaverManager_MMP
    @Injected private var networkManager: NetworkMonitoringManager_MMP
    @Injected private var coreDataStore: CoreDataStore_MMP
    @Injected private var networkingManager: NetworkMonitoringManager_MMP

    @ObservedObject var item: ParentMO

    @State private var imageData: Data?

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
        .onReceive(saveManager.didDownlaod_MMP, perform: presentDownloadSuccessPopUp)
    }
}

// MARK: Child View
private extension FavoritesDetailView_MMP {
    var     header: some View {
        HStack(spacing: 0) {
            RectangleButton_MMP(image: .iconBack) {
                navigator.pop()
            }
            Spacer()

            HStack(spacing: isIPad ? 40 : 20) {
                if contentType != .skins {
                    GeometryReader { geo in
                        RectangleButton_MMP(image: .iconShare) {
                            let rect = geo.frame(in: CoordinateSpace.global)
                            didTaspToShare(rect: rect)
                        }
                        .disableWithOpacity_MMP(!item.isLoadedToPhone)
                    }
                    .iosDeviceTypeFrameAspec_mmp(iOSWidth: 38, iOSHeight: 38, iPadWidth: 76, iPadHeight: 76)
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
                    LargeButton_MMP(
                        text: "Download",
                        isValid: !item.isLoadedToPhone,
                        lineWidth: 3,
                        asyncAction: {
                            await download()
                        }
                    )
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


}

// MARK: - Methods
private extension FavoritesDetailView_MMP {
    func download() async {
        guard networkManager.isReachable_MMP else {
            return
        }
        createSheet_mmp?(.init(type: .loading, firstAction: { _ in }, secondAction: {_ in }))
        let path = "\(contentType.folderName)/\(item.downloadPathOrEmpty)"
        await saveManager.downloadDidTap(file: (path, item.apkFileName))
    }

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

    func didTaspToShare(rect: CGRect) {
        saveManager.shareApk_MMP(apkFileName: item.apkFileName, rect: rect)
    }

    func presentDownloadSuccessPopUp(result: Result<SaveType_MMP, any Error>) {
        Task {
            switch result {
            case .success:
                item.isLoadedToPhone = true
                coreDataStore.saveChanges_MMP()

                createSheet_mmp?(.init(type: .loaded, firstAction: { _ in }, secondAction: { _ in }))
                try? await Task.sleep_MMP(seconds: 1)
                createSheet_mmp?(nil)
            case .failure:
                break
            }
        }
    }
}

// MARK: - computed property
extension FavoritesDetailView_MMP {
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

    return FavoritesDetailView_MMP(item: mod, contentType: .mods)
        .environment(\.managedObjectContext, moc)
}
