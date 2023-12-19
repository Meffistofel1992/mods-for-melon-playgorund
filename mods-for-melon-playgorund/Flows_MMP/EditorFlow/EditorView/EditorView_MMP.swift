//
//  EditorView_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI
import CoreData
import FlowStacks
import Resolver

struct EditorView_MMP: View {

    @Environment(\.createSheet_mmp) private var createSheet_mmp
    @StateObject private var editorController_MMP: EditorController_MMP
    @EnvironmentObject private var navigator: FlowNavigator<MainRoute_MMP>

    @State private var alert: AlertType?

    @Injected private var coreDataStore: CoreDataStore_MMP

    init(myMod: MyWorks) {
        _editorController_MMP = .init(wrappedValue: EditorController_MMP(myMod: myMod))
    }

    var body: some View {
        ZStackWithBackground_MMP {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    RectangleButton_MMP(image: .iconBack) {
                        didTapToBack()
                    }
                    Spacer()

                    RectangleButton_MMP(image: .iconChekcmark) {
                        didTapToSave()
                    }
                }
                .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 85, iPadIsAspect: true)
                .iosDeviceTypePadding_MMP(edge: .top, iOSPadding: 20, iPadPadding: 40)

                ScrollView {
                    VStack(spacing: 0) {
                        header
                            .zIndex(1001)

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
                ImagePicker(sourceType: .photoLibrary, selectedImage: $editorController_MMP.myMod.iconData)
            case .image:
                ImagePicker(sourceType: .photoLibrary, selectedImage: $editorController_MMP.myMod.imageData)
            }
        }
        .alert(
            alertTitle(),
            isPresented: $alert.mappedToBool(),
            actions: {
                alertButtons()
            }, message: {
                Text(alertMessage())
            })
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

            if let image = UIImage(data: editorController_MMP.myMod.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .iosDeviceTypeFrame_mmp(
                        iOSHeight: height,
                        iPadHeight: height
                    )
                    .clipShape(RoundedRectangle(cornerRadius: isIPad ? 24 : 12))
                    .iosDeviceTypePadding_MMP(edge: .all, iOSPadding: 20, iPadPadding: 40)
                    .frame(maxWidth: .infinity)
                    .addRoundedModifier_MMP(radius: isIPad ? 24 : 12)
            }
        }
    }
}

// MARK: - Methods
private extension EditorView_MMP {
    func didTapToSave() {
        if editorController_MMP.isDataEqual() {
            alert = .nothingToSave
        } else {
            coreDataStore.saveChanges_MMP()
            createSheet_mmp?(
                .init(
                    type: .saved,
                    firstAction: { _ in },
                    secondAction: { _ in }
                )
            )
            Task {
                try? await Task.sleep_MMP(seconds: 0.5)
                createSheet_mmp?(nil)
                navigator.pop()
            }
        }
    }

    func didTapToBack() {
        alert = .leaveWithoutSaving
    }
}

extension EditorView_MMP {
    enum AlertType {
        case nothingToSave
        case leaveWithoutSaving
    }

    @ViewBuilder
    private func alertButtons() -> some View {
        switch alert {
        case .nothingToSave:
            Button("Ok") { }

            Button("Back") {
                navigator.pop()
            }
        case .leaveWithoutSaving:
            Button("Yes") {
                navigator.pop()
            }

            Button("Save") {
                Task {
                    try? await Task.sleep_MMP(seconds: 0.2)
                    didTapToSave()
                }
            }
        default:
            EmptyView()
        }
    }

    func alertTitle() -> String {
        switch alert {
        case .nothingToSave:
            return "Nothing to save"
        case .leaveWithoutSaving:
            return "Are you sure?"
        default:
            return ""
        }
    }

    func alertMessage() -> String {
        switch alert {
        case .nothingToSave:
            return "Are your sure u want to leave?"
        case .leaveWithoutSaving:
            return "Are your sure u want to leave with no saving?"
        default:
            return ""
        }
    }
}

#Preview {
    let moc = CoreDataMockService_MMP.preview
    let myMod = CoreDataMockService_MMP.getMyWorks(with: moc)[0]
    
    return EditorView_MMP(myMod: myMod)
}
