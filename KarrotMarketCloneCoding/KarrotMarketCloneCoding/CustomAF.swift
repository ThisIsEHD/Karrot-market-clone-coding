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
    var header: RequestHeaders { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}

enum Purpose: Requestable {
    case login(User)
    case fetchUser(ID)
    case registerUser
    case update(User)
    case fetchItems([String : Any])
    case fetchItem(ProductID)
    case fetchUserSellingItems(ID, [String : Any])
    case fetchUserWishItems(ID, [String : Any])
    case registerItem(ID, Item)
    case deleteUser(ID)
    case addWishItem(ProductID, ID)
    case deleteWishItem(ProductID, ID)
    case fetchAllChats(ID, [String : Any])
    case fetchItemChatroom(ID, ChatroomId)
    case fetchMyItemChats(ID, ChatroomId)
    case connectWebSoket(ID, ChatroomId)
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
            case .fetchItems:
                return .none
            case .fetchItem:
                return .none
            case .fetchUserSellingItems:
                return .none
            case .fetchUserWishItems:
                return .jsonWithToken
            case .registerItem:
                return .multipartWithToken
            case .deleteUser:
                return .jsonWithToken
            case .addWishItem:
                return .jsonWithToken
            case .deleteWishItem:
                return .jsonWithToken
            case .fetchAllChats:
                return .jsonWithToken
            case .fetchItemChatroom:
                return .none
            case .fetchMyItemChats:
                return .none
            case .connectWebSoket:
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
            case .fetchItems:
                return "/api/v1/products"
            case .fetchItem(let productID):
                return "/api/v1/products/\(productID)"
            case .fetchUserSellingItems(let userId, _):
                return "/api/v1/users/\(userId)/products"
            case .fetchUserWishItems(let useId, _):
                return "/api/v1/users/\(useId)/products_wish"
            case .registerItem(let userID, _):
                return "/api/v1/users/\(userID)/products"
            case .deleteUser(let id):
                return "/api/v1/users/\(id)"
            case .addWishItem(let userId, let productID):
                return "api/v1/users/\(userId)/products/\(productID)/wish"
            case .deleteWishItem(let id, let productID):
                return "api/v1/users/\(id)/products/\(productID)/wish"
            case .fetchAllChats(let id, _):
                return "api/v1/users/\(id)/chatrooms"
            case .fetchItemChatroom(let id, let chatroomId):
                return "api/v1/users/\(id)/chatrooms/\(chatroomId)"
            case .fetchMyItemChats(let id, let chatroomId):
                return "api/v1/users/\(id)/chatrooms/\(chatroomId)/chats"
            case .connectWebSoket(let id, let chatroomId):
                return "api/v1/users/\(id)/chatrooms/\(chatroomId)/ws"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .login, .registerUser, .registerItem, .addWishItem: return .post
            case .fetchUser, .fetchItem, .fetchItems, .fetchUserSellingItems, .fetchUserWishItems, .fetchAllChats, .fetchItemChatroom, .fetchMyItemChats, .connectWebSoket: return .get
            case .update: return .put
            case .deleteUser, .deleteWishItem: return .delete
        }
    }
    
    var parameters: RequestParameters {
        switch self {
            case .login(let user): return .body(user)
            case .update(let user): return .body(user)
            case .fetchItems(let queryItem), .fetchUserSellingItems(_, let queryItem), .fetchUserWishItems(_, let queryItem), .fetchAllChats(_, let queryItem): return .query(queryItem)
            case .fetchUser, .registerUser, .fetchItem, .registerItem, .deleteUser, .addWishItem, .deleteWishItem, .fetchItemChatroom, .fetchMyItemChats, .connectWebSoket: return .none
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        let userId = UserDefaults.standard.object(forKey: Const.userId) as? String ?? ""
        let accessToken = KeyChain.read(key: userId) ?? ""
        print("userId: \(userId)")
        print("accessToken: \(accessToken)")
        var headers = HTTPHeaders()
        
//        header 구성
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
        
//        parameter 구성
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

typealias ID = String
typealias ProductID = Int
typealias ChatroomId = Int
