//
//  SearchTextField.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 13.12.2023.
//

import SwiftUI

struct SearchTextField_MMP: View {

    enum FocusField_MMP: Hashable {
        case field
      }

    @FocusState private var focusedField: FocusField_MMP?
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 0) {
            Image(.iconSearch)
                .renderingMode(.template)
                .resizable()
                .iosDeviceTypeFrameAspec_mmp(
                    iOSWidth: 24,
                    iOSHeight: 24,
                    iPadWidth: 48,
                    iPadHeight: 48
                )
                .foregroundStyle(Color.white)
                .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
                .iosDeviceTypePadding_MMP(edge: .leading, iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
                .iosDeviceTypePadding_MMP(edge: .trailing, iOSPadding: 8, iPadPadding: 16, iPadIsAspect: true)
                .onTapGesture {
                    focusedField = .field
                }
            TextField(text: $searchText) {
                Text("Search")
                    .iosDeviceTypeFont_mmp(
                        iOS: .init(name: .sfProDisplay, style: .regular, size: 16),
                        iPad: .init(name: .sfProDisplay, style: .regular, size: 32)
                    )
                    .foregroundStyle(Color.white)
            }
            .focused($focusedField, equals: .field)
            .foregroundStyle(Color.white)

            VStack {
                if !focusedField.isNil {
                    Button {
                        searchText = ""
                    } label: {
                        Image(.iconCancel)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .iosDeviceTypeFrameAspec_mmp(
                                iOSWidth: 24,
                                iOSHeight: 24,
                                iPadWidth: 48,
                                iPadHeight: 48
                            )
                    }
                    .transition(.scale)
                }
            }
            .animation(.default, value: focusedField)
            .iosDeviceTypePadding_MMP(edge: .trailing, iOSPadding: 12, iPadPadding: 24, iPadIsAspect: true)
        }
        .background {
            RoundedRectangle(cornerRadius: isIPad ? 24 : 12)
                .customfill_MMP()
                .addShadowToRectangle_mmp()
        }
    }
}

#Preview {
    SearchTextField_MMP(searchText: .constant(""))
}
