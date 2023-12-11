//
//  Optional+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 09.11.2023.
//

import Foundation

typealias MMP_Optional = Optional

protocol MMP_AnyOptional {
    var isNil: Bool { get }
}

extension MMP_Optional: MMP_AnyOptional {
    var isNil: Bool { self == nil }
}

extension MMP_Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
