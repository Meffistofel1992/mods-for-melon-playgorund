//
//  CustomSheet.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 16.11.2023.
//

import SwiftUI

typealias MMP_EnvironmentValues = EnvironmentValues

struct CreateSheetAction_MMP {
    typealias Action = ValueClosure_MMP<CustomSheetModel_MMP?>
    let action: Action
    func callAsFunction(_ note: CustomSheetModel_MMP?) {
        action(note)
    }
}

struct CreateSheetActionKey_MMP: EnvironmentKey {
    static var defaultValue: CreateSheetAction_MMP?
}

extension MMP_EnvironmentValues {
    var createSheet_mmp: CreateSheetAction_MMP? {
        get { self[CreateSheetActionKey_MMP.self] }
        set { self[CreateSheetActionKey_MMP.self] = newValue }
    }
}

extension MMP_View {
    func onCreateSheet_mmp(_ action: @escaping CreateSheetAction_MMP.Action) -> some View {
        self.environment(\.createSheet_mmp, CreateSheetAction_MMP(action: action))
    }
}
