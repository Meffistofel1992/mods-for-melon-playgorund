//
//  APIError_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation

enum APIError_MMP: Error {
    case checkUpdateError(type: ContentType_MMP, errorDescription: String)
    case invalidURL
    case unexpectedResponse
    case noInternetConnection
    case qiblaWithoutLocation
    case parseError(ContentType_MMP)
    case error(String)
}

extension APIError_MMP: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .noInternetConnection: return "Please check your internet connection and try again"
        case .qiblaWithoutLocation: return "Location permission is required in order to use Quibla Compass"
        case .parseError(let type): return "Parse error \(type.rawValue)"
        case let .checkUpdateError(type, errorDescription): return "Update Error \(type) - \(errorDescription)"
        case .error(let error): return error
        }
    }
}
