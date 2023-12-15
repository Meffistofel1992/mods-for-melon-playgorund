//
//  BottomSheetView.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI

struct BottomSheetView_MMP<Content: View>: View {

    @Binding var isShowing: Bool
    @Binding var isAppear: Bool

    let content: Content

    var body: some View {

        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isAppear = false
                            Task {
                                try? await Task.sleep_MMP(seconds: 0.3)
                                isShowing = false
                            }
                        }
                    }
                if isAppear {
                    content
                        .zIndex(1000)
                }
            }

        }
        .task {
            withAnimation {
                isAppear = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    BottomSheetView_MMP(
        isShowing: .constant(true),
        isAppear: .constant(true),
        content: EmptyView()
    )
}


