//
//  ModsView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 15.12.2023.
//

import SwiftUI
import Resolver
import FlowStacks

struct HomeListView_MMP<T: ParentMO>: View {

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
                if mods.isEmpty && !searchText.isEmpty {
                    Text("No found results")
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(Color.white)
                        .iosDeviceTypeFont_mmp(
                            iOS: .init(name: .sfProDisplay, style: .medium, size: 20),
                            iPad: .init(name: .sfProDisplay, style: .medium, size: 40)
                        )
                } else {
                    gridView(data: mods)
                }
            }
        }
    }

    func gridView(data: FetchedResults<T>) -> some View {
        CategoryList_MMP(data: data) { item in
            VStack(spacing: 0) {
                let height = Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 168/1024 : 93/390)

                AsyncLoadingImage_MMP(
                    path: "/\(contentType.folderName)/\(item.imagePath ?? "")",
                    size: .init(
                        width: .zero,
                        height: height
                    ),
                    isNeedFit: contentType == .skins
                )
                .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 12))
                .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 12, iPadPadding: 24)


                Text(item.title ?? "")
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .bold, size: 16),
                        iPad: .init(name: .sfProDisplay, style: .bold, size: 26)
                    )
                    .foregroundStyle(.white)
                    .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 8, iPadPadding: 8)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)

                Text(item.desctiptionn ?? "")
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .regular, size: 12),
                        iPad: .init(name: .sfProDisplay, style: .regular, size: 22)
                    )
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            .onTapGesture {
                navigator.push(.detailMod(item, contentType))
            }
            .iosDeviceTypePadding_MMP(edge: [.horizontal], iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
            .frame(maxWidth: .infinity)
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12, isNeeedShadow: false)
            .overlay(alignment: .topTrailing) {
                Button {
                    item.isFavourite.toggle()
                    coreDataStore.saveChanges_MMP()
                } label: {
                    Image(item.isFavourite ? .iconBookmarkFill : .iconBookmark)
                        .resizable()
                        .iosDeviceTypeFrameAspec_mmp(iOSWidth: 20, iOSHeight: 20, iPadWidth: 40, iPadHeight: 40)
                }
                .iosDeviceTypeFrameAspec_mmp(iOSWidth: 28, iOSHeight: 28, iPadWidth: 50, iPadHeight: 50)
                .addRoundedModifier_MMP(radius: 8, isNeeedShadow: false)
                .iosDeviceTypePadding_MMP(edge: [.top, .trailing], iOSPadding: 7, iPadPadding: 16, iPadIsAspect: true)

            }
            .addShadowToRectangle_mmp()
        }
    }
}

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return HomeListView_MMP(searchText: "", contentType: .mods)
        .environment(\.managedObjectContext, moc)
}
