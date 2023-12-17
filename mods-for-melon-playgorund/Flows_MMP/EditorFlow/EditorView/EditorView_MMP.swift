//
//  EditorView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI
import CoreData
import FlowStacks

struct EditorView_MMP: View {

    @StateObject private var editorController_MMP: EditorController_MMP
    @EnvironmentObject private var navigator: FlowNavigator<MainRoute_MMP>

    init(moc: NSManagedObjectContext) {
        _editorController_MMP = .init(wrappedValue: EditorController_MMP(moc: moc))
    }

    var body: some View {
        ZStackWithBackground_MMP {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    RectangleButton_MMP(image: .iconBack) {
                        navigator.pop()
                    }
                    Spacer()

                    RectangleButton_MMP(image: .iconChekcmark) {

                    }
                }
                .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)

                ScrollView {
                    VStack(spacing: 0) {
                        header

                        switch editorController_MMP.selectionDropDownContent.value {
                        case .miscTemplates:
                            EditorMistTemplates_MMP()
                                .environmentObject(editorController_MMP)
                        case .setCollider:
                            EditorColider_MMP()
                                .environmentObject(editorController_MMP)
                        case .selectTexture:
                            EditorSetTexture_MMP()
                                .environmentObject(editorController_MMP)
                        case .setProperties:
                            EditorProperty_MMP()
                                .environmentObject(editorController_MMP)
                        }
                        Spacer()
                    }
                    .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                    .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 20, iPadPadding: 40)
                }
                .padding(.top, 1)
            }
        }
        .sheet(item: $editorController_MMP.imageState) { item in
            switch item {
            case .icon:
                ImagePicker(sourceType: .photoLibrary, selectedImage: $editorController_MMP.myMod.iconData ?? Data())
            case .image:
                ImagePicker(sourceType: .photoLibrary, selectedImage: $editorController_MMP.myMod.imageData ?? Data())
            }
        }
    }
}

// MARK: - Child Views
private extension EditorView_MMP {
    var header: some View {
        VStack(spacing: 0) {
            DropDown_MMP(
                content: editorController_MMP.dropDownContent,
                selection: $editorController_MMP.selectionDropDownContent,
                dynamic: false
            )
            .iosDeviceTypePadding_MMP(edge: .bottom, iOSPadding: 20, iPadPadding: 40)

            let height = Utilities_MMP.shared.widthWith_MMP(aspectRatio: isIPad ? 290/1024 : 125/390)

            Image(.imageMock)
                .resizable()
                .scaledToFit()
                .iosDeviceTypeFrame_mmp(
                    iOSHeight: height,
                    iPadHeight: height
                )
                .iosDeviceTypePadding_MMP(edge: .vertical, iOSPadding: 20, iPadPadding: 40)
                .frame(maxWidth: .infinity)
                .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
        }
    }
}

#Preview {
    EditorView_MMP(moc: CoreDataMockService_MMP.preview)
}

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
