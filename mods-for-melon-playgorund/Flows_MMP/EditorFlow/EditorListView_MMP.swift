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
            EditorListRowView_MMP(item: item) { data in
                guard let data else {
                    return
                }

                let mod = MyWorks(
                    moc: coreDataStore.viewContext,
                    item: item,
                    imageData: data
                )

                navigator.push(.editor(mod))
            }
        }
    }
}

#Preview {
    let moc = CoreDataMockService_MMP.preview

    return EditorListView_MMP(contentType: .living)
        .environment(\.managedObjectContext, moc)
}

