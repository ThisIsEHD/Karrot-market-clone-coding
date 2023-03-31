//
//  KarrotResponse.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/22/23.
//

import Foundation

protocol KarrotResponse<KarrotData>: Codable {
    associatedtype KarrotData
    
    var message: String? { get }
    var data: KarrotData { get }
}

struct KarrotResponseError: KarrotResponse {
    typealias KarrotData = String?
    
    var message: String?
    var data: String?
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
    case internalServerError
    
    case decodingError
    case unknownError
}
