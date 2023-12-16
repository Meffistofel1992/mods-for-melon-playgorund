//
//  ContentView.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @State private var splashScreenIsShow: Bool = false
    @State private var sheetType: CustomSheetModel_MMP?

    var body: some View {
        VStack(spacing: 0) {
            //        if splashScreenIsShow {
            TabFlowView()
            //        } else {
            //            SplashScreen_MMP(splashScreenIsShow: $splashScreenIsShow)
            //        }
        }
        .showCustomSheet(sheetType: $sheetType)
        .onCreateSheet_mmp { type in
            withAnimation(.default.speed(1)) {
                sheetType = type
            }
        }
    }
}


#Preview {
    ContentView()
}
