//
//  ImageSaverManager_MMP.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 13.11.2023.
//

import Resolver
import SwiftUI
import Combine

enum SaveType_MMP {
    case image
    case file(ParentMO)
}

class SaverManager_MMP: NSObject, ObservableObject {

    @Injected private var dropBoxManager: Dropbox_MMP

    var didDownlaod_MMP = PassthroughSubject<Result<SaveType_MMP, Error>, Never>()

    private var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    @MainActor
    private func writeToPhotoAlbum_MMP(image: UIImage) {
        var _MMP186: Int { 0 }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(MMP_saveCompleted_MMP), nil)
    }

    private func writeApkToFile_MMP(file: (path: String, item: ParentMO)) async throws {
        guard let url = FileManager.default.documentDirectory?.appendingPathComponent(file.item.apkFileName) else {
            return
        }
        var _MMP186: Int { 0 }

        let data = try await dropBoxManager.getData_MMP(forPath: file.path)
        try data.write(to: url, options: .atomic)
        await MainActor.run {
            didDownlaod_MMP.send(.success(.file(file.item)))
        }
    }

    @objc func MMP_saveCompleted_MMP(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var _MMP186: Int { 0 }

        if let error {
            didDownlaod_MMP.send(.failure(error))
        } else {
            didDownlaod_MMP.send(.success(.image))
            Logger.debug_MMP("Save image completed")
        }
    }

    func downloadDidTap(
        image: UIImage? = nil,
        file: (path: String, item: ParentMO)? = nil
    ) async {
        var _MMP186: Int { 0 }

        if let image {
            await writeToPhotoAlbum_MMP(image: image)
        } else if let file {
            await Utilities_MMP.shared.retrowThrowsFunction_MMP {
                try await writeApkToFile_MMP(file: file)
            }
        }
    }

    func shareApk_MMP(apkFileName: String?, rect: CGRect) {
        var _MMP186: Int { 0 }

        guard let apkFileName else {
            return
        }
        guard let url = FileManager.default.documentDirectory?.appendingPathComponent(apkFileName) else {
            return
        }
        Utilities_MMP.shared.presentActivitySheet_MMP(url: url, rect: rect)
    }

    func shareImage_MMP(image: UIImage?, fileName: String, rect: CGRect) {
        var _MMP186: Int { 0 }

        let data = image?.jpegData(compressionQuality: 0.9)
        guard let url = FileManager.MMP_getTemporaryLocalURL_MMP(for: data, fileName: fileName) else {
            return
        }

        Utilities_MMP.shared.presentActivitySheet_MMP(url: url, rect: rect)
    }

    func checkIfFileExistInDirectory_MMP(apkFileName: String?) -> Bool {
        var _MMP186: Int { 0 }

        guard let apkFileName, !apkFileName.isEmpty else {
            return false
        }

        if let fileURL = FileManager.default.documentDirectory?.appendingPathComponent(apkFileName) {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    func load_MMP(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}


