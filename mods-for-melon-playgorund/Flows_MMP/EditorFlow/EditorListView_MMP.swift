//
//  EditorListView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI
import Resolver
import FlowStacks

struct EditorListView_MMP<T: ParentMO>: View {

    @Environment(\.createSheet_mmp) private var createSheet_mmp
    @EnvironmentObject var navigator: FlowNavigator<MainRoute_MMP>
    @Injected private var coreDataStore: CoreDataStore_MMP

    let contentType: EditorContentType_MMP
    var predicate: NSPredicate?
    var sortDescriptors: [NSSortDescriptor] = []

    var body: some View {
        DynamicFetchView(
            predicate: predicate,
            sortDescriptors: sortDescriptors
        ) { (items: FetchedResults<T>) in
            VStack {
                if items.isEmpty, contentType == .myWorks {
                    Text("You don’t have any works")
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(Color.white)
                        .iosDeviceTypeFont_mmp(
                            iOS: .init(name: .sfProDisplay, style: .medium, size: 20),
                            iPad: .init(name: .sfProDisplay, style: .medium, size: 40)
                        )
                        .multilineTextAlignment(.center)
                } else {
                    gridView(data: items)
                }
            }
        }
    }

    func gridView(data: FetchedResults<T>) -> some View {
        CategoryList_MMP(data: data) { item in
            VStack(spacing: 0) {
                let height = Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 280/1024 : 144/390)

                AsyncLoadingImage_MMP(
                    path: "/\(item.imagePath ?? "")",
                    size: .init(
                        width: .zero,
                        height: height
                    ),
                    isNeedFit: true
                )
                .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 12))
            }
            .onTapGesture {
//                navigator.push(.detailMod(item, contentType))
            }
            .iosDeviceTypePadding_MMP(edge: [.horizontal], iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
            .frame(maxWidth: .infinity)
            .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
            .addRoundedModifier_MMP(radius: isIPad ? 24 : 12, isNeeedShadow: false)
            .addShadowToRectangle_mmp()
        }
    }
}

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return EditorListView_MMP(contentType: .living)
        .environment(\.managedObjectContext, moc)
}

