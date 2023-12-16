//
//  DynamicFetchView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 14.12.2023.
//

import CoreData
import SwiftUI

struct DynamicFetchView<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>

    let content: (FetchedResults<T>) -> Content

    init(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        animation: Animation? = nil,
        @ViewBuilder content : @escaping (FetchedResults<T>) -> Content
    ) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: sortDescriptors, predicate: predicate, animation: animation)
        self.content = content
    }

    var body: some View {
        content(fetchRequest)
    }
}

#Preview {
    return DynamicFetchView { (result: FetchedResults<ModsMO>) in
        Text("Sasha")
    }
    .environment(\.managedObjectContext, CoreDataMockService_MMP.preview)
}

//extension DynamicFetchView where T : ModsMO {
//
//    init( withSearchText searchText: String, @ViewBuilder content: @escaping (FetchedResults<T>) -> Content) {
//
//        let search_criteria = "name CONTAINS[c] %@"
//        let predicate = NSPredicate(format: search_criteria, searchText )
//
//        self.init(withPredicate: predicate, content: content)
//    }
//}
