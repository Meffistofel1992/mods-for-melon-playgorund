//
//  Task+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 16.11.2023.
//

import Foundation

typealias MMP_Task = Task

extension MMP_Task where Success == Never, Failure == Never {
    static func sleep_MMP(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        await Task.sleep(duration)
    }
}
