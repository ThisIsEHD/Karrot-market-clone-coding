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
    
    // FCM
    case registerFCMToken(String)
    
    // User
    case login(User)
    case logout
    case registerUser
    
    // Item
    case fetchItems([String: Any])
    case fetchFavoriteItems
    case fetchSellItems([String: Any])
    case fetchItemDetail(ProductID)
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
        case .fetchFavoriteItems:
            return "/favorites"
        case .fetchSellItems:
            return "/post/my-sales-list"
        case .logout:
            return "/logout"
        case .fetchItemDetail(let productID):
            return "/post/\(productID)"
            
            // post
        case  .registerFCMToken:
            return "/members/register-fcmtoken"
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
        case .fetchItems,
             .fetchItemDetail,
             .fetchFavoriteItems,
             .fetchSellItems,
             .logout:
        return .get
            
            // post
        case .registerFCMToken,
             .login,
             .registerUser,
             .registerItem:
        return .post
         
            // delete
        }
    }
    
    var header: RequestHeaders {
        switch self {
            
        case .registerFCMToken, .login:
            return .json
        case .registerUser, .registerItem:
            return .multipart
        case .fetchItems, .fetchFavoriteItems, .fetchSellItems, .fetchItemDetail, .logout:
            return .none
        }
    }
    
    var parameters: RequestParameters {
        switch self {
            // body
        case .registerFCMToken(let token): return .body(token)
        case .login(let user): return .body(user)
            // query
        case .fetchItems(let queryItem): return .query(queryItem)
        case .fetchSellItems(let queryItem): return .query(queryItem)
            // none
        case .registerUser, .registerItem, .fetchFavoriteItems, .logout, .fetchItemDetail: return .none
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

func handleResponse<T: Codable>(_ response: DataResponse<T, AFError>) -> Result<T, KarrotError> {
    if let error = response.error {
        print(error)
    }
    
    guard let httpResponse = response.response else {
        return  .failure(.serverError)
    }
    
    switch httpResponse.statusCode {
    case (200...299):
        
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
        
        guard let data = response.data, let response = jsonDecode(type: KarrotResponse<String>.self, data: data) else {
            return .failure(.decodingError)
        }
        print(response.message ?? "에러 위치: \(#function)")
        
        return .failure(.unknownError(statusCode: httpResponse.statusCode))
    }
}

func getImage(url: String?, size: CGSize? = nil) async -> Result<UIImage, KarrotError> {
    guard let stringURL = url else {
        return .failure(.unwrappingError)
    }
    
    let response = await AF.download(stringURL).serializingData().response
    
    guard let data = response.value, let image = UIImage(data: data) else {
        return .failure(.unwrappingError)
    }
    
    guard let size = size else {
        return .success(image)
    }

    let resizedImage = image.resize(to: size)
    return .success(resizedImage)
}

typealias ID = String
typealias ProductID = Int
