//
//  DropBoxManager_MMP.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import Foundation

import Foundation
import SwiftyDropbox
import DataCache


struct DropBoxKeys_MMP {
    static let appkey = "oxgt0xv8z7rqum7"
    static let appSecret = "g8al018czh6g4jt"
    static let authCode = "czHFetFkAxAAAAAAAAAERnze66OpFiUfZlyS02t6IJY"
    static let apiLink = "https://api.dropboxapi.com/oauth2/token"
    static let refreshToken = "Kft8R7EcAJIAAAAAAAAAASrZri6M8FFxFglkitUDX625v1T3zD0Dyj2ZbeE2cHwl"
}


final class Dropbox_MMP : NSObject {

    public var client : DropboxClient?
    private let userDefaults = UserDefaults.standard

    func initDropBox_MMP() {
        DropboxClientsManager.setupWithAppKey(DropBoxKeys_MMP.appkey)

        Task {
            do {
                try await getAuthorizedClient_MMP()
                Logger.debug_MMP("Success Authorized client")
            } catch {
                Logger.error_MMP(error)
            }
        }
    }
//    private func getRefreshToken() async {
//        do {
//            let refreshToken = try await getReshreshToken(authCode: DropBoxKeys_MMP.authCode)
//            let accessToken = try await getAccessToken(refreshToken: refreshToken)
//            client = DropboxClient(accessToken: accessToken)
//            print("good job first open token 🫡 \(accessToken),\(String(describing: client))")
//        } catch {
//            Logger.error_MMP(error)
//        }
//    }
}

// MARK: - Async Await
extension Dropbox_MMP {

    func uploadJSONFile_MMP(filePath: String, from urlFrom: URL) async throws -> String? {
        let client = try await getAuthorizedClient_MMP()

        return try await upload_MMP(client: client, filePath: filePath, from: urlFrom)
    }

    func downloadModel_MMP<T: Codable>(filePath: String) async throws -> T {
        let json = try await downloadData_MMP(filePath: filePath)

        return try JSONDecoder().decode(T.self, from: json)
    }

    func downloadData_MMP(filePath: String) async throws -> Data {
        let client = try await getAuthorizedClient_MMP()

        return try await download_MMP(client: client, filePath: filePath)
    }

    func removeFolder_MMP(_ filePath: String) async throws {
        let client = try await getAuthorizedClient_MMP()

        client.files.deleteV2(path: filePath)
    }

    // MARK: - File download link
    func getFileDownloadLink_MMP(filePath: String) async throws -> URL? {

        let filePath = filePath.starts(with: "/") ? filePath : "/" + filePath
        let client = try await getAuthorizedClient_MMP()

        return try await getTemporaryLink_MMP(client: client, filePath: filePath)
    }

    func getData_MMP(forPath path: String) async throws -> Data {
        let path = path.starts(with: "/") ? path : "/" + path

        if let data = DataCache.instance.readData(forKey: path) {
           return data
        } else {
            let data = try await downloadData_MMP(filePath: path)
            DataCache.instance.write(data: data, forKey: path)
            return data
        }
    }

    func getMetaData_MMP(type: ContentType_MMP) async throws -> Bool {
        let client = try await getAuthorizedClient_MMP()

        return try await getMetaData_MMP(client: client, type: type)
    }

    func writeToCash_MMP(forPath path: String) async throws{
        let path = path.starts(with: "/") ? path : "/" + path

        if DataCache.instance.readData(forKey: path).isNil {
            let data = try await downloadData_MMP(filePath: path)
            DataCache.instance.write(data: data, forKey: path)
        }
    }

    func getFromCache_MMP(forPath path: String) -> Data? {
        DataCache.instance.readData(forKey: path)
    }
}

// MARK: - Convert sync to async
private extension Dropbox_MMP {

    // MARK: - Temporary Link
    func getTemporaryLink_MMP(client: DropboxClient, filePath: String) async throws -> URL? {
        try await withCheckedThrowingContinuation { continuation in
            self.getTemporaryLink_MMP(client: client, filePath: filePath) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }

    func getTemporaryLink_MMP(client: DropboxClient, filePath: String, completion: @escaping ValueClosure_MMP<Result<URL?, Error>>) {
        client.files.getTemporaryLink(path: filePath).response { response, error in
            if let result = response {
                completion(.success(URL(string: result.link)))
            } else if let error = error {
                completion(.failure(APIError_MMP.error("Error getting temporary link: \(error)")))
            }
        }
    }

    // MARK: - Download
    func download_MMP(client: DropboxClient, filePath: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.download_MMP(client: client, filePath: filePath) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }

    func download_MMP(client: DropboxClient, filePath: String, completion: @escaping ValueClosure_MMP<Result<Data, Error>>) {
        client.files.download(path: filePath).response { response, error in
            if let response {
                let data = response.1
//                Logger.debug_MMP(data.prettyPrintedJSONString ?? "")
                completion(.success(data))
            } else if let error {
                completion(.failure(APIError_MMP.error("Error downloading JSON file for path: \(filePath), \nerror: \(error)")))
            }
        }
    }

    // MARK: - Upload
    func upload_MMP(client: DropboxClient, filePath: String, from urlFrom: URL) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            self.upload_MMP(client: client, filePath: filePath, from: urlFrom) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }

    func upload_MMP(client: DropboxClient, filePath: String, from urlFrom: URL, completion: @escaping ValueClosure_MMP<Result<String,Error>>) {
        client.files.upload(path: filePath, mode: .overwrite, input: urlFrom).response { response, error in
            if let _ = response {
                return completion(.success("JSON file uploaded to Dropbox: \(filePath)"))
            } else if let error = error {
                return completion(.failure(APIError_MMP.error(error.description)))
            }
        }
    }

    // MARK: - MetaData
    func getMetaData_MMP(client: DropboxClient, type: ContentType_MMP) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            self.getMetaData(client: client, type: type) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
    func getMetaData(
        client: DropboxClient,
        type: ContentType_MMP,
        completion: @escaping ValueClosure_MMP<Result<Bool, Error>>
    ) {
        client.files.getMetadata(path: type.downloadPath).response(completionHandler: { data, error in
            if let data = data as? Files.FileMetadata {
                if data.size == self.userDefaults.integer(forKey: "bytes\(type.rawValue)") {
                    completion(.success(false))
                } else {
                    self.userDefaults.set(Int(data.size), forKey: "bytes\(type.rawValue)")
                    completion(.success(true))
                }
            } else if let error = error {
                completion(.failure(APIError_MMP.checkUpdateError(type: type, errorDescription: error.description)))
            } else {
                completion(.failure(APIError_MMP.error("unknownError")))
            }
        })
    }
}

// MARK: - Refresh & Access token & Authorize
private extension Dropbox_MMP {
    func getReshreshToken_MMP(authCode: String) async throws -> String {

        let username = DropBoxKeys_MMP.appkey
        let password = DropBoxKeys_MMP.appSecret
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        let parameters : Data = "code=\(authCode)&grant_type=authorization_code".data(using: .utf8)!
        let url = URL(string: DropBoxKeys_MMP.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters

        let (data, response) = try await URLSession.shared.data(for: apiRequest)

        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError_MMP.unexpectedResponse
        }
        guard HTTPCodes_MMP.success.contains(code) else {
            throw APIError_MMP.unexpectedResponse
        }

        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

        if let responseJSON = responseJSON as? [String: Any], let token = responseJSON["refresh_token"] as? String {
            return token
        }

        throw APIError_MMP.error("Access token error")
    }


    func getAccessToken_MMP(refreshToken: String) async throws -> String {
        let username = DropBoxKeys_MMP.appkey
        let password = DropBoxKeys_MMP.appSecret
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        let parameters : Data = "refresh_token=\(refreshToken)&grant_type=refresh_token".data(using: .utf8)!
        let url = URL(string: DropBoxKeys_MMP.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters

        let (data, response) = try await URLSession.shared.data(for: apiRequest)

        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError_MMP.unexpectedResponse
        }
        guard HTTPCodes_MMP.success.contains(code) else {
            throw APIError_MMP.unexpectedResponse
        }

        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

        if let responseJSON = responseJSON as? [String: Any], let token = responseJSON["access_token"] as? String {
            return token
        }

        throw APIError_MMP.error("Access token error")
    }

    @discardableResult
    func getAuthorizedClient_MMP() async throws -> DropboxClient {
        if let client {
            return client
        } else {
            let accessToken = try await getAccessToken_MMP(refreshToken: DropBoxKeys_MMP.refreshToken)

            if let client = client {
                return client
            } else {
                let client = DropboxClient(accessToken: accessToken)
                self.client = client

                return client
            }
        }
    }
}
