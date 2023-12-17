//
//  EditorView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

struct EditorView_MMP: View {

    @StateObject private var editorController_MMP = EditorController_MMP()

    var body: some View {
        ZStackWithBackground_MMP {
            ScrollView {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        RectangleButton_MMP(image: .iconBack) {

                        }
                        Spacer()

                        RectangleButton_MMP(image: .iconChekcmark) {

                        }
                    }
                    .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)

                    DropDown_MMP(
                        content: editorController_MMP.dropDownContent,
                        selection: $editorController_MMP.selectionDropDownContent,
                        dynamic: false
                    )
                    Spacer()
                }
                .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 20, iPadPadding: 40)
            }
            .padding(.top, 1)
        }
    }
}

#Preview {
   EditorView_MMP()
}
