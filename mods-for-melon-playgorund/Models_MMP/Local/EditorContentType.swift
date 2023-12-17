//
//  dsad.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 17.12.2023.
//

import Foundation

enum EditorContentType_MMP: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case living = "Living"
    case miscTemplate = "Misc"
    case myWorks = "My works"
}
