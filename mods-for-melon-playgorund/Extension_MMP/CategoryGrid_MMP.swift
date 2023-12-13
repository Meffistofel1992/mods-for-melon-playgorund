//
//  CategoryGrid_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//

import SwiftUI

struct CategoryList_MMP<Content: View, Data: RandomAccessCollection>: View where Data.Element: Hashable, Data.Element: Identifiable {

    let data: Data
    let content: BuilderClosureValue_MMP<Data.Element, Content>

    private var containerPadding: (EdgeInsets)
    private let iOsColumns: [GridItem]
    private let iPadColumns: [GridItem]
    private let vStackSpacing: CGFloat

    init(
        data: Data,
        gridiPadSpacing: CGFloat = isIPad ? 24 : 14,
        containerPadding: EdgeInsets = .init(
            top: isIPad ? 40 : 20,
            leading: isIPad ? 85 : 20,
            bottom: isIPad ? 32 : 16,
            trailing: isIPad ? 85 : 20
        ),
        vStackSpacing: CGFloat = isIPad ? Utilities_MMP.shared.widthAspectRatioDevice_MMP(width: 24) : 14,
        content: @escaping BuilderClosureValue_MMP<Data.Element, Content>
    ) {
        self.containerPadding = containerPadding
        self.data = data
        self.content = content
        self.vStackSpacing = vStackSpacing

        iOsColumns = [
            GridItem(.flexible(), spacing: gridiPadSpacing),
            GridItem(.flexible())
        ]

        iPadColumns = [
            GridItem(.flexible(), spacing: Utilities_MMP.shared.widthAspectRatioDevice_MMP(width: gridiPadSpacing)),
            GridItem(.flexible(), spacing: Utilities_MMP.shared.widthAspectRatioDevice_MMP(width: gridiPadSpacing)),
            GridItem(.flexible())
        ]
    }

    var body: some View {
        let columns = isIPad ? iPadColumns : iOsColumns

        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: vStackSpacing) {
                ForEach(data) { number in
                    content(number)
                }
            }
            .iosDeviceTypePadding_MMP(
                edge: .leading,
                iOSPadding: containerPadding.leading,
                iPadPadding: containerPadding.leading,
                iPadIsAspect: true
            )
            .iosDeviceTypePadding_MMP(
                edge: .trailing,
                iOSPadding: containerPadding.trailing,
                iPadPadding: containerPadding.trailing,
                iPadIsAspect: true
            )
            .iosDeviceTypePadding_MMP(
                edge: .top,
                iOSPadding: containerPadding.top,
                iPadPadding: containerPadding.top,
                iPadIsAspect: true
            )
            .iosDeviceTypePadding_MMP(
                edge: .bottom,
                iOSPadding: containerPadding.bottom,
                iPadPadding: containerPadding.bottom,
                iPadIsAspect: true
            )
        }
    }
}

#Preview {
    HomeView_MMP()
}
