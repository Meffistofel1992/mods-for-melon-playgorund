//
//  EditorListRowView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

struct EditorListRowView_MMP: View {

    let item: ParentMO
    var didTapToRow: ValueClosure_MMP<Data?>

    @State private var data: Data?

    var body: some View {
        VStack(spacing: 0) {
            let height = Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 280/1024 : 144/390)

            AsyncLoadingImage_MMP(
                path: "/\(item.imagePath ?? "")",
                size: .init(
                    width: .zero,
                    height: height
                ),
                isNeedFit: true,
                imageDidLoad: { data = $0 }
            )
            .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 12))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            didTapToRow(data)
        }
        .iosDeviceTypePadding_MMP(edge: [.horizontal], iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
        .frame(maxWidth: .infinity)
        .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
        .addRoundedModifier_MMP(radius: isIPad ? 24 : 12, isNeeedShadow: false)
        .addShadowToRectangle_mmp()
    }
}
