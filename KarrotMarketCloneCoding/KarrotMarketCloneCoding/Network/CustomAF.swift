//
//  CustomAF.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/08/02.
//

import Foundation
import Alamofire

protocol Requestable: URLRequestConvertible {
    var baseUrl: String { get }
    var header: RequestHeaders { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}
enum RequestHeaders {
    case json
    case multipart
    case none
}

enum Header: String {
    case contentType = "Content-Type"
    case json = "application/json"
    case multipart = "multipart/form-data"
    
    var type: String {
        return self.rawValue
    }
}

enum RequestParameters {
    case body(_ parameter: Encodable?)
    case query([String : Any])
    case none
}

enum KarrotRequest: Requestable {
    
    // User
    case login(User)
    case logout
    case registerUser
    
    // Item
    case fetchItems([String : Any])
    //    case fetchItem(ID,ProductID)
    case registerItem
}

extension KarrotRequest {
    var baseUrl: String {
        return "http://43.201.9.139:8080/api/v1"
    }
    
    var path: String {
        switch self {
            
            // get
        case .fetchItems:
            return "/post/home-list"
        case .logout:
            return "/logout"
            //case .fetchItem(let userId, let productID):
            //     return ""
            
            // post
        case .login:
            return "/login"
        case .registerUser:
            return "/members"
        case .registerItem:
            return "/post"
            
            // put
            
            // delete
        }
    }
    
    var method: HTTPMethod {
        switch self {
            // get
        case .fetchItems, .logout: return .get
            // post
        case .login, .registerUser, .registerItem: return .post
            // post
            // delete
        }
    }
    
    var header: RequestHeaders {
        switch self {
            
        case .login: return .json
        case .registerUser, .registerItem:  return .multipart
        case .fetchItems, .logout: return .none
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .login(let user): return .body(user)
        case .fetchItems(let queryItem): return .query(queryItem)
        case .registerUser, .registerItem, .logout: return .none
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        var headers = HTTPHeaders()
        
        guard let cookies = HTTPCookieStorage.shared.cookies else { fatalError("cookie 없음")}
        let cookiesHeader = HTTPCookie.requestHeaderFields(with: cookies)
        
        switch header {
        case .json:
            headers = [ Header.contentType.type : Header.json.type ]
        case .multipart:
            headers = [ Header.contentType.type: Header.multipart.type ]
        case .none:
            break
        }
        
        for (key, value) in cookiesHeader {
            headers.add(HTTPHeader(name: key, value: value))
        }
        
        urlRequest.headers = headers
        
        switch parameters {
        case .body(let parameter):
            let jsonParameter = parameter?.toJSONData()
            urlRequest.httpBody = jsonParameter
        case .none:
            return urlRequest
        case .query(let query):
            return try URLEncoding.default.encode(urlRequest, with: query)
        }
        return urlRequest
    }
}

typealias ID = String
typealias ProductID = Int
