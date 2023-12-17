//
//  DropDown_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import SwiftUI

// MARK: Custom View Builder
struct DropDown_MMP: View {

    /// - Drop Down Properties
    let content: [DropDownSelection]
    @Binding var selection: DropDownSelection
    var dynamic: Bool = true
    var height: CGFloat = isIPad ? 96 : 48
    var prompt: String = ""

    /// - View Properties
    @State private var expandView: Bool = false
    @State private var disableInteraction: Bool = false

    var body: some View{
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader {
                let size = $0.size

                VStack(alignment: .leading,spacing: 0){
                    if !dynamic {
                        RowView(selection, size)
                            .padding(.bottom, 8)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(content.filter { dynamic ? true : $0.id != selection.id }) { object in
                            RowView(object, size)
                        }
                    }
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: isIPad ? 24 : 12, style: .continuous)
                    )
                    .preferredColorScheme(.dark)
                    .background {
                        RoundedRectangle(cornerRadius: isIPad ? 24 : 12)
                            .customfill_MMP(Color.c6B7CB8)
                            .addShadowToRectangle_mmp()
                    }
                }

                /// - Moving View Based on the Selection
                .offset(y: dynamic ? (CGFloat(content.firstIndex(of: selection) ?? 0) * -height) : 0)
            }

            .frame(height: height)
            .overlay(alignment: .trailing) {
                Image(.iconBack)
                    .resizable()
                    .iosDeviceTypeFrame_mmp(
                        iOSWidth: 24,
                        iOSHeight: 24,
                        iPadWidth: 44,
                        iPadHeight: 44
                    )
                    .rotationEffect(.init(degrees: expandView ? 90 : 270))
                    .iosDeviceTypePadding_MMP(edge: .trailing, iOSPadding: 20, iPadPadding: 40)
            }
            .mask(alignment: .top){
                RoundedRectangle(cornerRadius: isIPad ? 24 : 12)
                    .frame(height: expandView ? CGFloat(content.count) * height + (isIPad ? 20 : 10) : height)
                /// - Moving the Mask Based on the Selection, so that Every Content Will be Visible
                /// - Visible Only When Content is Expanded
                    .offset(y: expandView ? (CGFloat(content.firstIndex(of: selection) ?? 0) * -height) : 0)
            }
            .background(content: {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    Color.primary
                        .opacity(0.001)
                        .onTapGesture {
                            closeView(selection)
                        }
                        .offset(x: -rect.minX,y: -rect.minY)
                }
                .frame(width: screenSize.width, height: screenSize.height)
                .position()
                .ignoresSafeArea()
            })
        }
        .zIndex(selection.zIndex)
        .modifier(OptionalClipper(condition: selection.zIndex == 0))
    }

    /// - Row View
    @ViewBuilder
    func RowView(_ object: DropDownSelection,_ size: CGSize) -> some View{
        let currentIndex = Double(content.firstIndex(of: object) ?? 0)

        HStack(spacing: 10) {
            if let image = object.image {
                Image(image)
            }
            Text(object.value.rawValue)
                .iosDeviceTypeFont_mmp(
                    iOS: .init(name: .sfProDisplay, style: .medium, size: 20),
                    iPad: .init(name: .sfProDisplay, style: .medium, size: 40)
                )
                .foregroundColor(.white)
        }
        .iosDeviceTypePadding_MMP(edge: .horizontal, iOSPadding: 20, iPadPadding: 40)
        .frame(width: size.width, height: size.height, alignment: .leading)
        .background {
            if selection == object {
                RoundedRectangle(cornerRadius: isIPad ? 24 : 12)
                    .customfill_MMP()
                    .addShadowToRectangle_mmp()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard !disableInteraction else{return}
            /// - If Expanded then Make Selection
            if expandView{
                closeView(object)
            } else {
                expandView(object)
            }
            /// - Disabling Interaction While Animating
            disableInteraction = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                disableInteraction = false
            }
        }
        .zIndex(lastSelectionIndex < currentSelectionIndex ? (Double(content.count) - currentIndex) : currentSelectionIndex)

        if selection != object {
            Divider()
                .overlay {
                    Color.c9C88E9
                        .frame(height: 0.3)
                }
                .padding(.horizontal)
        }
    }

    /// - Closes Drop Down View
    func closeView(_ object: DropDownSelection){
        withAnimation(.easeInOut(duration: 0.35)){
            expandView = false
            selection.lastSelection = selection.value
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                selection.zIndex = 0.0
            }
            /// - Disabling Animation for Non-Dynamic Contents
            if dynamic{
                selection = object
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                    selection = object
                }
            }
        }
    }

    /// - Expands Drop Down View
    func expandView(_ object: DropDownSelection){
        withAnimation(.easeInOut(duration: 0.35)){
            /// - Disabling Outside Taps
            if selection == object {
                selection.zIndex = 1000.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        expandView = true
                    }
                }
            }
        }
    }

    var lastSelectionIndex: Double{
        return Double(content.firstIndex(where: { selection.lastSelection == $0.lastSelection }) ?? 0)
    }

    var currentSelectionIndex: Double{
        return Double(content.firstIndex(of: selection) ?? 0)
    }
}

struct DropDownSelection: Hashable, Identifiable {
    let id: UUID = UUID()
    var value: EditorViewType = .miscTemplates
    var image: String?
    var lastSelection: EditorViewType = .miscTemplates
    var zIndex: Double = 0.0
}

struct OptionalClipper: ViewModifier{
    var condition: Bool = false

    func body(content: Content) -> some View {
        if condition{
            content
                .clipped()
                .contentShape(Rectangle())
        } else {
            content
                .transition(.identity)
        }
    }
}

extension View {
    var screenSize: CGSize {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size ?? .zero
    }
}


//#Preview {
//    VStack {
//        EditorView_MMP(moc: CoreDataMockService_MMP.preview)
//    }
//}
