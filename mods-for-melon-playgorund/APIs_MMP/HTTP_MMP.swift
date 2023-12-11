//
//  HTTP_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation

enum HTTPMethod_MMP: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum HTTPHeadersKey_MMP: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case contentDisposition = "Content-Disposition"
    case contentLength = "Content-Length"
    case applicationId = "X-Parse-Application-Id"
    case restApiKey = "X-Parse-REST-API-Key"
}

typealias HTTPCode_MMP = Int
typealias HTTPCodes_MMP = Range<Int>
typealias HTTPHeaders_MMP = [String: String]
typealias Parameters_MMP = [String: Any]

extension HTTPCodes_MMP {
    static let success = 200 ..< 300
}

