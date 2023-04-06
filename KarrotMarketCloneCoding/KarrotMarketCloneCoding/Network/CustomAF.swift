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
        print(cookiesHeader)
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

func handleResponse(_ response: DataResponse<Bool, AFError>) -> Result<Bool, KarrotError> {
    if let error = response.error {
        print(error)
    }
    
    guard let httpResponse = response.response else {
        return  .failure(.serverError)
    }
    
    switch httpResponse.statusCode {
    case 200:
        return .success(true)
    case 401:
        return .failure(.unauthorized)
    case 403:
        return .failure(.forbidden)
    case 404:
        return .failure(.notFound)
    default:
        guard let data = response.data, let error = jsonDecode(type: KarrotResponseError.self, data: data) else {
            return .failure(.decodingError)
        }
        print(error)
        return .failure(.unknownError)
    }
}

func handleResponse<T: Codable>(_ response: DataResponse<T, AFError>) -> Result<T, KarrotError> {
    if let error = response.error {
        print(error)
    }
    
    guard let httpResponse = response.response else {
        return  .failure(.serverError)
    }
    
    switch httpResponse.statusCode {
    case 200:
        guard let responseBody = response.data,
              let responseData = jsonDecode(type: T.self, data: responseBody) else {
            return .failure(.decodingError)
        }
        return .success(responseData)
    case 401:
        return .failure(.unauthorized)
    case 403:
        return .failure(.forbidden)
    case 404:
        return .failure(.notFound)
    default:
        guard let data = response.data, let error = jsonDecode(type: KarrotResponseError.self, data: data) else {
            return .failure(.decodingError)
        }
        print(error)
        return .failure(.unknownError)
    }
}

typealias ID = String
typealias ProductID = Int
