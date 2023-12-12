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

    var body: some View {
        SplashScreen_MMP(splashScreenIsShow: $splashScreenIsShow)
    }
}


#Preview {
    ContentView()
}
