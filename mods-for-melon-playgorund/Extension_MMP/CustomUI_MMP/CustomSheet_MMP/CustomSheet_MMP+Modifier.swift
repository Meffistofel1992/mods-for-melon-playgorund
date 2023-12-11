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
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                }
            }
            .overlay {
                VStack {
                    if let sheetType {
                        sheet(with: sheetType)
                            .transition(.opacity)
                    }
                }
            }
    }

    @ViewBuilder
    private func sheet(with model: CustomSheetModel_MMP) -> some View {
        switch model.type {
        case .loading:
            EmptyView()
//            CustomSheetView.loading_MMP()
            //        case .proceedWithCaution:
            //            CustomSheetView.processWithCaution(
            //                firstAction: { model.firstAction(.cancel) },
            //                secondAction: { model.secondAction(.delete) }
            //            )
        }
    }
}

extension MMP_View {
    func showCustomSheet(sheetType: Binding<CustomSheetModel_MMP?>) -> some View {
        modifier(CustomSheetModifier_MMP(sheetType: sheetType))
    }
}
