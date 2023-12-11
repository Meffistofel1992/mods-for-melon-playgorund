//
//  Closure+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import Foundation

typealias EmptyClosure_MMP = () -> Void
typealias ValueClosure_MMP<T> = (T) -> Void
typealias ValueReturnClosure_MMP<T, V> = (T) -> V
typealias AsyncValueClosure_MMP<T> = (T) async -> Void
typealias AsyncEmptyClosure_MMP = () async -> Void
typealias AsyncThrowEmptyClosure_MMP = () async throws -> Void
typealias BuilderClosure_MMP<T> = () -> T
typealias BuilderClosureValue_MMP<V, T> = (V) -> T
