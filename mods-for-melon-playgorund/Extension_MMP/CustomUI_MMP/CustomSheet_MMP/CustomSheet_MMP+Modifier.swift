//
//  CustomSheet+Modifier.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 16.11.2023.
//

import SwiftUI

struct CustomSheetModifier_MMP: ViewModifier {

    @Binding var sheetType: CustomSheetModel_MMP?

    func body(content: Content) -> some View {
        content
            .onAppear { print("") }
            .blur(radius: !sheetType.isNil ? 5 : 0, opaque: true)
            .ignoresSafeArea()
            .overlay {
                if !sheetType.isNil {
                    Color.c232323
                        .ignoresSafeArea()
                }
            }
            .overlay {
                VStack {
                    if let sheetType {
                        sheet(with: sheetType)
                            .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 40)
                            .transition(.opacity)
                    }
                }
            }
    }

    @ViewBuilder
    private func sheet(with model: CustomSheetModel_MMP) -> some View {
        switch model.type {
        case .loading:
            CustomSheetView_MMP.loading_MMP()
        case .loaded:
            CustomSheetView_MMP.loaded_MMP()
        case .removeFavoutire(let type):
            CustomSheetView_MMP.removeFavourite_MMP(
                contentType: type,
                firstAction: { model.firstAction(.cancel) },
                secondAction: { model.secondAction(.remove) }
            )
        case .removeMOds(let title):
            CustomSheetView_MMP.removeMods_MMP(
                title: title,
                firstAction: { model.firstAction(.cancel) },
                secondAction: { model.secondAction(.mods) }
            )
        case .cancelEditor:
            CustomSheetView_MMP.cancelEditor_MMP(
                firstAction: { model.firstAction(.cancel) },
                secondAction: { model.secondAction(.yes) }
            )
        case .saved:
            CustomSheetView_MMP.saved_MMP()
        }
    }
}

extension MMP_View {
    func showCustomSheet(sheetType: Binding<CustomSheetModel_MMP?>) -> some View {
        modifier(CustomSheetModifier_MMP(sheetType: sheetType))
    }
}
