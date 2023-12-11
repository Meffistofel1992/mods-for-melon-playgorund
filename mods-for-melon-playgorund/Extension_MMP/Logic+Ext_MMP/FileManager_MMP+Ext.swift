//
//  FileManager+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 13.11.2023.
//

import Foundation

typealias FileManager_MMP = FileManager

extension FileManager_MMP {

    static func MMP_generateTemporaryURL_MMP(nameWithExtension: String) -> URL {
        let normalisedName = nameWithExtension.lowercased()
        return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(normalisedName)
    }

    static func MMP_getTemporaryLocalURL_MMP(for data: Data?, fileName: String) -> URL? {
        guard let data else { return nil }

        let filePath = fileName.contains("/") ? (fileName as NSString).lastPathComponent : fileName
        let url = FileManager.MMP_generateTemporaryURL_MMP(nameWithExtension: filePath)

        do {
            try data.write(to: url, options: Data.WritingOptions.atomic)
        } catch {
            print("error while writing data to \(filePath)", error)
            return nil
        }
        return url
    }

    var documentDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
