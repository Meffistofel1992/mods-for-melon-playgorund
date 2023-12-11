//
//  ForEach+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 23.11.2023.
//

import SwiftUI

func ForEachWithIndex_MMP<
    Data: RandomAccessCollection,
    Content: View>(
    _ data: Data,
    @ViewBuilder content: @escaping (Data.Index, Data.Element) -> Content
) -> some View where Data.Element: Identifiable, Data.Element: Hashable {
    ForEach(Array(zip(data.indices, data)), id: \.1) { index, element in
        content(index, element)
    }
}

struct ForEachWithIndexHashable_MMP<
    Data: RandomAccessCollection,
    Content: View
>: View where Data.Element: Hashable {
    let data: Data
    @ViewBuilder let content: (Int, Data.Element) -> Content

    var body: some View {
        ForEach(Array(data.enumerated()), id: \.offset) { index, element in
            content(index, element)
        }
    }
}
