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
                headerButtons

                HomeDetailCardView_MMP(
                    item: item,
                    imageData: $imageData,
                    contentType: contentType,
                    action: handleLargeButton
                )
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
private extension HomeDetailView_MMP {
    var headerButtons: some View {
        HStack(spacing: 0) {
            RectangleButton_MMP(image: .iconBack) {
                if navigator.routes.count > 0 {
                    navigator.pop()
                }
            }
            Spacer()

            HStack(spacing: isIPad ? 40 : 20) {

                switch contentType {
                case .mods:
                    GeometryReader { geo in
                        let rect = geo.frame(in: CoordinateSpace.global)

                        RectangleButton_MMP(image: .iconShare) {
                            didTaspToShare(rect: rect)
                        }
                        .disableWithOpacity_MMP(!item.isLoadedToPhone)
                    }
                    .iosDeviceTypeFrame_mmp(iOSWidth: 38, iOSHeight: 38, iPadWidth: 76, iPadHeight: 76)

                    RectangleButton_MMP(image: .iconPencil) {
                        didTapToEditor()
                    }
                case .skins:
                    GeometryReader { geo in
                        RectangleButton_MMP(image: .iconDownload) {
                            let rect = geo.frame(in: CoordinateSpace.global)
                            if !item.isLoadedToPhone {
                                Task {
                                    await download()
                                    try? await Task.sleep_MMP(seconds: 1)
                                    didTaspToShare(rect: rect)
                                }
                            } else {
                                didTaspToShare(rect: rect)
                            }
                        }
                    }
                    .iosDeviceTypeFrame_mmp(iOSWidth: 38, iOSHeight: 38, iPadWidth: 76, iPadHeight: 76)
                default:
                    EmptyView()

                }
                RectangleButton_MMP(image: favouriteIcon) {
                    didTapToBookmark()
                }
            }
        }
    }
}

// MARK: - Methods
private extension HomeDetailView_MMP {
    var favouriteIcon: ImageResource {
        item.isFavourite ? .iconBookmarkFill : .iconBookmark
    }

    func download() async {
        guard networkManager.isReachable_MMP else {
            return
        }
        createSheet_mmp?(.init(type: .loading, firstAction: { _ in }, secondAction: {_ in }))
        let path = "\(contentType.folderName)/\(item.downloadPathOrEmpty)"
        await saveManager.downloadDidTap(file: (path, item))
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
        guard let data = imageData else {
            return
        }
        let myWork = MyWorks(moc: coreDataStore.viewContext, item: item, imageData: data)
        navigator.push(.editor(myWork))
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

    func handleLargeButton(action: DetailAction) {
        switch action {
        case .download:
            Task {
                await download()
            }
        case .share(let rect):
            didTaspToShare(rect: rect)
        }
    }
}

#Preview {

    let moc = CoreDataMockService_MMP.preview
    let mod = CoreDataMockService_MMP.createMods(with: moc)[0]

    return HomeDetailView_MMP(item: mod, contentType: .mods)
        .environment(\.managedObjectContext, moc)
}
