//
//  Network.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/25.
//

import Foundation
import Alamofire

protocol Requestable: URLRequestConvertible {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}

enum RequestParameters {
    case body(_ parameter: Encodable?)
    case none
}

enum Header: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
    
    var type: String {
        return self.rawValue
    }
}

struct LoginResponse {
    let accessToken: String
    let refreshToken: String?
    var userId: String? { return accessToken.getUserId() }
}

extension String {
    func getUserId() -> UserId? {
        let encodedUserId = self.components(separatedBy: ".")[1]
        guard let data = Data(base64Encoded: encodedUserId), let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any], let userId = jsonData["user_id"] as? String else { return nil }
        return userId
    }
}

struct MyInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken"), let userId = accessToken.getUserId() else {
                  completion(.success(urlRequest))
                  return
              }
        
        var request = urlRequest
        request.url?.appendPathComponent("/\(userId)")
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
    }
}

enum Purpose {
    case login(Credential)
    case fetchUser
    case registerUser(User)
    case update(User)
}

extension Purpose: Requestable {
    
    var baseUrl: String {
        return "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com"
    }
    
    var path: String {
        switch self {
            case .login:
                return "/api/v1/users/auth/login"
            case .fetchUser, .registerUser, .update:
                return "/api/v1/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .login: return .post
            case .fetchUser: return .get
            case .registerUser: return .post
            case .update: return .put
        }
    }
        
    var parameters: RequestParameters {
        switch self {
            case .login(let credential): return .body(credential)
            case .registerUser(let user): return .body(user)
            case .fetchUser: return .none
            case .update(let user): return .body(user)
        }
    }
    
}

extension Purpose {
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.headers = HTTPHeaders([HTTPHeader.contentType(Header.json.type)])
        
        switch parameters {
            case .body(let parameter):
                let jsonParameter = parameter?.toJSONData()
                urlRequest.httpBody = jsonParameter
            case .none:
                return urlRequest
        }
        return urlRequest
    }
}

extension Encodable {
    func toJSONData() -> Data? {
        let jsonData = try? JSONEncoder().encode(self)
        return jsonData
    }
}

extension Data {
    func toDictionary() -> [String: Any] {
        guard let dictionaryData = try? JSONSerialization.jsonObject(with: self) as? [String: Any] else { return [:] }
        return dictionaryData
    }
}

typealias Token = String
typealias UserId = String

struct Network {
    
    static let shared = Network()
    
    func register(user: User) {
        AF.request(Purpose.registerUser(user)).response { response in
            if let err = response.error{    //응답 에러
                print(err)
                return
            }
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                print("success")
                guard let data = response.data, let jsonData = String(data: data, encoding: String.Encoding.utf8) else { return }
                print(jsonData)
                
            } else if let data = response.data {
                let json = data.toDictionary()
                print(response.response?.statusCode as Any)
                print("Failure Response: \(json)")
            }
        }
    }
    
    func auth(email: String, pw: String, completion: @escaping (Token) -> Void) {
        let credential = Credential(email: email, pw: pw)
        AF.request(Purpose.login(credential)).response { response in
            guard let httpResponse = response.response else { return }
            print(response.request?.httpBody?.toDictionary())
            switch httpResponse.statusCode {
                case 200:
                    guard let token = httpResponse.allHeaderFields["Authorization"] as? String else { fatalError() }
                    completion(token)
                case 400:
                    guard let data = response.data else { fatalError() }
                    let json = data.toDictionary()
                    print("Failure Response: \(json)")
                    return
                case 401:
                    print("비밀번호를 다시 입력해주세요")
                    return
                case 404:
                    print("존재하지 않는 사용자입니다.")
                    return
                default:
                    print("서버에러")
                    break
            }
        }
        
        // response 정보처리모듈화 필요.
    }
    
    func fetch(user: UserId, token: Token, completion: @escaping (User?) -> Void) {
        AF.request(Purpose.fetchUser, interceptor: MyInterceptor()).response { response in
            if let err = response.error{    //응답 에러
                print(err)
                return
            }
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                print("success")
                guard let data = response.data, let jsonData = String(data: data, encoding: String.Encoding.utf8) else { return }
                print(jsonData)
                
            } else if let data = response.data {
                let json = data.toDictionary()
                print(response.response?.statusCode as Any)
                print("Failure Response: \(json)")
                fatalError()
            }
        }
    }
    
//    func fetchMerchandises(keyword: String? = nil, number: Int? = nil, category: Int? = nil, sort: Sort? = nil, last: Int? = nil) -> Merchandises {
//        
//        let url = "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com/api/v1/products"
//        var merchandises = Merchandises(keyword: nil, category: nil, products: [], size: 0)
//        
//        AF.request(url).validate().validate(contentType: ["application/json"]).responseData { response in
//            
//            switch response.result {
//                
//            case .success(let data):
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    
//                    jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.myDateFormatter)
//                    
//                    let decodedMerchandises = try jsonDecoder.decode(Merchandises.self, from: data)
//                    
//                    merchandises = decodedMerchandises
//                    
//                } catch(let error) {
//                    print(error.localizedDescription)
//                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        return merchandises
//    }
    
    func httpGetJSON<T: Codable>(url: String, in type: T.Type, completion: @escaping ((T)?) -> (Void)) {
        
        AF.request(url).validate().validate(contentType: ["application/json"]).responseData { response in
            
            switch response.result {
                
            case .success(let data):
                let decodedData = jsonDecode(type: type, data: data)
                
                completion(decodedData)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func jsonDecode<T: Codable>(type: T.Type, data: Data) -> T? {
        
        let jsonDecoder = JSONDecoder()
        let result: Codable?
        
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.myDateFormatter)
        
        do {
            
            result = try jsonDecoder.decode(type, from: data)
            
            return result as? T
        } catch {
            
            print(error)
            
            return nil
        }
        
    }
    
    func getMerchandisesListFetchingURL(keyword: String? = nil, number: Int? = nil, category: Int? = nil, sort: Sort? = nil, last: Int? = nil) -> String{
        
        var url = "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com/api/v1/products?"
        var isFirstQuery = true
        
        if keyword == nil, number == nil, category == nil, sort == nil, last == nil {
            url.remove(at: url.index(before: url.endIndex))
        }
        
        if let keyword = keyword {
            
            if isFirstQuery == true {
                
                url.append(contentsOf: "keyword=\(keyword)")
                isFirstQuery = false
            }
        }
        
        if let number = number {
            
            if isFirstQuery == true{
                
                url.append(contentsOf: "number=\(number)")
                isFirstQuery = false
            } else {
                url.append(contentsOf: "&number=\(number)")
            }
            
        }
        
        if let category = category {
            
            if isFirstQuery == true {
                
                url.append(contentsOf: "category=\(category)")
                isFirstQuery = false
            } else {
                url.append(contentsOf: "&category=\(category)")
            }
        }
        
        if let sort = sort {
            
            if isFirstQuery == true {
                
                url.append(contentsOf: "sort=\(sort)")
                isFirstQuery = false
            } else {
                url.append(contentsOf: "&sort=\(sort)")
            }
        }
        
        if let last = last {
            
            if isFirstQuery == true {
                
                url.append(contentsOf: "last=\(last)")
                isFirstQuery = false
            } else {
                url.append(contentsOf: "&last=\(last)")
            }
        }
        
        return url
    }
    
//    func fetchMerchandises(keyword: String? = nil, number: Int? = nil, category: Int? = nil, sort: Sort? = nil, last: Int? = nil) -> [Merchandise] {
//
//        var url = "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com/api/v1/products?"
//        var isFirstQuery = true
//
//        if keyword == nil, number == nil, category == nil, sort == nil, last == nil {
//            url.remove(at: url.endIndex)
//        }
//
//        if let keyword = keyword {
//            if isFirstQuery == true {
//                url.append(contentsOf: "keyword=\(keyword)")
//                isFirstQuery = false
//            }
//        }
//
//        if let number = number {
//            if isFirstQuery == true{
//                url.append(contentsOf: "number=\(number)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&number=\(number)")
//            }
//
//        }
//
//        if let category = category {
//            if isFirstQuery == true {
//                url.append(contentsOf: "category=\(category)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&category=\(category)")
//            }
//        }
//
//        if let sort = sort {
//            if isFirstQuery == true {
//                url.append(contentsOf: "sort=\(sort)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&sort=\(sort)")
//            }
//        }
//
//        if let last = last {
//            if isFirstQuery == true {
//                url.append(contentsOf: "last=\(last)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&last=\(last)")
//            }
//        }
//
////        var merchandises = Merchandises(keyword: nil, category: nil, products: [], size: 0)
//        var merchandises = [Merchandise]()
//
//        AF.request(url).validate().validate(contentType: ["application/json"]).responseData { response in
//
//            switch response.result {
//
//            case .success(let data):
//                do {
//                    let jsonDecoder = JSONDecoder()
//
//                    jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.myDateFormatter)
//
//                    let decodedMerchandises = try jsonDecoder.decode(MerchandisesList.self, from: data)
//
//                    merchandises = decodedMerchandises.products
//
//
//                } catch(let error) {
//                    print(error.localizedDescription)
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        return merchandises
//    }
}
