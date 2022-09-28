//
//  CustomAF.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/08/02.
//

import Foundation
import Alamofire

// Alamofire의 URLRequest을 커스텀 해서  사용 AF.request(URLRequestConvertible)
protocol Requestable: URLRequestConvertible {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}

enum Purpose: Requestable {
    case login(Credential)
    case fetchUser(ID)
    case registerUser
    case update(User)
    case fetch([String : Any])
}

extension Purpose {
    var baseUrl: String {
        return "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com"
    }
    
    var header: RequestHeaders {
        switch self {
        case .login:
            return .json
        case .registerUser:
            return .multipart
        case .fetchUser:
            return .jsonWithToken
        case .update:
            return .jsonWithToken
        case .fetch:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/v1/users/auth/login"
        case .registerUser:
            return "/api/v1/users"
        case .fetchUser(let id):
            return "/api/v1/users/\(id)"
        case .update(let user):
            return "/api/v1/users/\(user.id ?? "")"
        case .fetch:
            return "/api/v1/products"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .fetchUser: return .get
        case .registerUser: return .post
        case .update: return .put
        case .fetch: return .get
        }
    }
        
    var parameters: RequestParameters {
        switch self {
            case .login(let credential): return .body(credential)
            case .registerUser: return .none
            case .fetchUser: return .none
            case .update(let user): return .body(user)
            case .fetch(let queryItem): return .query(queryItem)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        let userId = UserDefaults.standard.object(forKey: Const.userId.asItIs) as? String ?? ""
        let accessToken = KeyChain.read(key: userId) ?? ""
        var headers = HTTPHeaders()
        
        switch header {
        case .json:
            headers = [ Header.contentType.type : Header.json.type ]
        case .jsonWithToken:
            headers = [ Header.contentType.type: Header.json.type, Header.authorization.type : accessToken ]
        case .multipart:
            headers = [ Header.contentType.type: Header.multipart.type ]
        case .multipartWithToken:
            headers = [ Header.contentType.type: Header.multipart.type, Header.authorization.type : accessToken ]
        case .none: break
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

enum RequestHeaders {
    case json
    case jsonWithToken
    case multipart
    case multipartWithToken
    case none
}

enum RequestParameters {
    case body(_ parameter: Encodable?)
//    case query(_ parameter: QueryItem)
    case query([String : Any])
    case none
}

enum Header: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    
    case json = "application/json"
    case multipart = "multipart/form-data"
    
    var type: String {
        return self.rawValue
    }
}

struct MyInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken"), let userId = accessToken.getUserId() else {
//                  completion(.success(urlRequest))
//                  fatalError()
//              }
        
//        var request = urlRequest
//        request.url?.appendPathComponent("/\(userId)")
//        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
//        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
//            completion(.doNotRetryWithError(error))
//            return
//        }
    }
}

typealias ID = String
