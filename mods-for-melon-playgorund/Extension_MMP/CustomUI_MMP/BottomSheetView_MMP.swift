//
//  BottomSheetView.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

struct BottomSheetView_MMP<Content: View>: View {

    @Binding var isShowing: Bool

    let content: Content

    var body: some View {

        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                content
                    .zIndex(1000)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)

    }
}

#Preview {
    BottomSheetView_MMP(isShowing: .constant(true), content: EmptyView())
}


