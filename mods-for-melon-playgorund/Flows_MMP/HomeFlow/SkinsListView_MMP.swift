//
//  SkinsListView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 16.12.2023.
//

import SwiftUI
import Resolver
import FlowStacks

struct SkinsListView_MMP<T: ParentMO>: View {

    @Environment(\.createSheet_mmp) private var createSheet_mmp
    @EnvironmentObject var navigator: FlowNavigator<MainRoute_MMP>
    @Injected private var coreDataStore: CoreDataStore_MMP

    var searchText: String = ""
    let contentType: ContentType_MMP
    var predicate: NSPredicate?
    var sortDescriptors: [NSSortDescriptor] = []

    var body: some View {
        DynamicFetchView(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ) { (mods: FetchedResults<T>) in
            VStack {
                gridView(data: mods)
            }
        }
    }

    func gridView(data: FetchedResults<T>) -> some View {
        CategoryList_MMP(data: data, numberOfColumns: 1) { item in
            HStack(spacing: 12) {
                let height = Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 168/1024 : 90/390)

                AsyncLoadingImage_MMP(
                    path: "/\(contentType.folderName)/\(item.imagePath ?? "")",
                    size: .init(
                        width: .zero,
                        height: height
                    ),
                    isNeedFit: contentType == .skins
                )
                .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 12))
                .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 14, iPadPadding: 28)
                .iosDeviceTypeFrameAspec_mmp(
                    iOSWidth: 148,
                    isiOsAspec: true,
                    iPadWidth: 296,
                    isiPadAspec: true
                )
                .background {
                    RoundedRectangle(cornerRadius: isIPad ? 16 : 8)
                        .fill()
                }


                VStack(alignment: .leading, spacing: 0) {
                    Text(item.titleOrEmpty)
                        .iosDeviceTypeFont_mmp(
                            iOS: .init(name: .mitr, style: .medium, size: 18),
                            iPad: .init(name: .mitr, style: .medium, size: 36)
                        )
                        .foregroundStyle(.white)
                        .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 4, iPadPadding: 8)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)

                    Text(item.descriptionOrEmpty)
                        .iosDeviceTypeFont_mmp(
                            iOS: .init(name: .sfProDisplay, style: .medium, size: 14),
                            iPad: .init(name: .sfProDisplay, style: .medium, size: 28)
                        )
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Spacer()

                    HStack(spacing: isIPad ? 24 : 12) {
                        RectangleButton_MMP(
                            image: item.isFavourite ? .iconBookmarkFill : .iconBookmark,
                            iOsImageSize: 20,
                            iOsButtonSize: 28,
                            ipaImagedSize: 40,
                            ipaButtonSize: 56
                        ) {

                        }

                        RectangleButton_MMP(
                            image: .iconDownload,
                            iOsImageSize: 20,
                            iOsButtonSize: 28,
                            ipaImagedSize: 40,
                            ipaButtonSize: 56
                        ) {

                        }
                        Spacer()
                    }
                }
                .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 10, iPadPadding: 20)
            }
            .onTapGesture {
                navigator.push(.detailMod(item, contentType))
            }
            .iosDeviceTypePadding_MMP(edge: [.horizontal], iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
            .frame(maxWidth: .infinity)
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12, isNeeedShadow: false)
            .addShadowToRectangle_mmp()
        }
    }
}

// MARK: - Methods
extension SkinsListView_MMP {
    func didTapToBookmark(item: ParentMO) {
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
}

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return HomeView_MMP()
        .environment(\.managedObjectContext, moc)
}
