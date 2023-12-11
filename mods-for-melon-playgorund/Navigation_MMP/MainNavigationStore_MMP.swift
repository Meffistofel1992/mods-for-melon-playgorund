//
//  MainNavigationStore_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import SwiftUI
import FlowStacks

final class MainNavigationStore_MMP: ObservableObject {
    @Published var routes: Routes<MainRoute_MMP> = [.root(.home, embedInNavigationView: true)]
}
