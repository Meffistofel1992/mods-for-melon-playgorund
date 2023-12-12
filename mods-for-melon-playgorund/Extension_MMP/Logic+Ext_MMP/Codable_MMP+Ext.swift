//
//  Codable_MMP+Ext.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation

typealias Encodable_MMP = Encodable
typealias Sequence_MMP = Sequence


extension Encodable_MMP {
    func data(using encoder: JSONEncoder = .init()) throws -> Data { try encoder.encode(self) }
    func string(using encoder: JSONEncoder = .init()) throws -> String { try data(using: encoder).string! }
    func dictionary(using encoder: JSONEncoder = .init(), options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: try data(using: encoder), options: options) as? [String: Any] ?? [:]
    }
}

extension MMP_Data {
    func json(using encoder: JSONEncoder = .init(), options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] ?? [:]
    }
}

extension MMP_Data {
    func decodedObject<D: Decodable>(using decoder: JSONDecoder = .init()) throws -> D {
        try decoder.decode(D.self, from: self)
    }
}

extension Sequence_MMP where Element == UInt8 {
    var string: String? { String(bytes: self, encoding: .utf8) }
}
