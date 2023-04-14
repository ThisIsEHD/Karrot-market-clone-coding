//
//  KarrotResponse.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import Foundation

protocol Response<KarrotData>: Codable {
    associatedtype KarrotData
    
    var message: String? { get }
    var data: KarrotData { get }
}

struct KarrotResponse<T: Codable>: Response {
    typealias KarrotData = T?
    
    var message: String?
    var data: T?
}

enum KarrotError: Error {
    
    // 400
    case badRequest
    // 401
    case unauthorized
    // 403
    case forbidden
    // 404
    case notFound
    // 500
    case serverError
    
    case decodingError
    case imageError
    case unwrappingError
    case unknownError(statusCode: Int)
}
