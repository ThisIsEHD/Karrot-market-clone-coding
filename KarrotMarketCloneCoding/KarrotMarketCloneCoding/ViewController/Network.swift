//
//  Network.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/25.
//

import Foundation
import Alamofire
import JWTDecode

typealias Token = String
typealias UserId = String

enum KarrotError: Error {
    case invalidToken
    case wrongPassword
    case duplicatedEmail
    case duplicatedNickName
    case unknownUser
    
    case serverError
}

struct Network {
    
    static let shared = Network()
    
    func register(user: User, image: UIImage?, completion: @escaping (Result<Data?,KarrotError>) -> ()) {
        
        guard let imageData = (image ?? UIImage(named: "user-selected"))?.jpegData(compressionQuality: 0.5) else { return }
        guard let jsonData = try? JSONEncoder().encode(user) else { return }

        AF.upload(multipartFormData: { data in

            data.append(imageData, withName: "file", fileName: "file")
            data.append(jsonData, withName: "json")
        }, with: Purpose.registerUser).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
            case 201:
                completion(.success(.none))
            case 400:
                completion(.failure(.serverError))
            case 422:
                guard let data = response.data else { return }
                let user = jsonDecode(type: User.self, data: data)
                
                if user?.email != nil { completion(.failure(.duplicatedEmail)) }
                else if user?.nickName != nil { completion(.failure(.duplicatedNickName))}
                else { completion(.failure(.serverError)) }
            default:
                completion(.failure(.serverError))
            }
        }
    }
    
    func auth(email: String, pw: String, completion: @escaping (Result<Data?,KarrotError>) -> Void) {
        
        let credential = Credential(email: email, pw: pw)
        
        AF.request(Purpose.login(credential)).response { response in
            if let _ = response.error{    //응답 에러
                completion(.failure(.serverError))
            }
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
            case 200:
                guard let token = httpResponse.allHeaderFields["Authorization"] as? String else {
                    completion(.failure(.serverError))
                    return
                }
                do {
                    let jwt = try decode(jwt: token)
                    print(jwt)
                    guard let id = jwt.body["user_id"] else { return }
                    UserDefaults.standard.removeObject(forKey: Const.userId.asItIs)  //로그아웃시로 빼버릴거. keychain에서 토큰도 삭제해야.
                    UserDefaults.standard.set(id, forKey: Const.userId.asItIs)
                    KeyChain.create(key: id as! String, token: token)
                    
                    completion(.success(.none))
                }
                catch { completion(.failure(.serverError)) }
                
            case 400:
                guard let data = response.data else { fatalError() }
                let json = data.toDictionary()
                
                print("Auth Failure Response: \(json)")
                completion(.failure(.serverError))
            case 401:
                completion(.failure(.wrongPassword))
            case 404:
                completion(.failure(.unknownUser))
            default:
                completion(.failure(.serverError))
            }
        }
    }
    
    func fetchUser(id: String, completion: @escaping (Result<User,KarrotError>) -> Void) {
        
        AF.request(Purpose.fetchUser(id)).response { response in
            if let _ = response.error{    //응답 에러
                completion(.failure(.serverError))
            }
            guard let httpResponse = response.response else { return }
            switch httpResponse.statusCode {
            case 200:
                guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                    completion(.failure(.serverError))
                    return
                }
                completion(.success(user))
            case 401:
                completion(.failure(.invalidToken))
            case 403, 404:
                completion(.failure(.unknownUser))
            default:
                completion(.failure(.serverError))
            }
        }
    }
    
    func fetchItems(completion: @escaping (FetchedMerchandisesList?) -> ()) {
        AF.request(Purpose.fetch(QueryItem(keyword: nil, size: nil, category: nil, sort: nil, last: nil))).response { response in
            if let err = response.error {
                print("🛑",err)
                return
            }
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                guard let data = response.data else { return }
                
                completion(jsonDecode(type: FetchedMerchandisesList.self, data: data))

            } else if let data = response.data {
                let json = data.toDictionary()
                print("Register Failure Response: \(json)")
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
    
    
    
    
    
    
    
//    func getMerchandisesListFetchingURL(keyword: String? = nil, number: Int? = nil, category: Int? = nil, sort: Sort? = nil, last: Int? = nil) -> String{
//
//        var url = "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com/api/v1/products?"
//        var isFirstQuery = true
//
//        if keyword == nil, number == nil, category == nil, sort == nil, last == nil {
//            url.remove(at: url.index(before: url.endIndex))
//        }
//
//        if let keyword = keyword {
//
//            if isFirstQuery == true {
//
//                url.append(contentsOf: "keyword=\(keyword)")
//                isFirstQuery = false
//            }
//        }
//
//        if let number = number {
//
//            if isFirstQuery == true{
//
//                url.append(contentsOf: "number=\(number)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&number=\(number)")
//            }
//
//        }
//
//        if let category = category {
//
//            if isFirstQuery == true {
//
//                url.append(contentsOf: "category=\(category)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&category=\(category)")
//            }
//        }
//
//        if let sort = sort {
//
//            if isFirstQuery == true {
//
//                url.append(contentsOf: "sort=\(sort)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&sort=\(sort)")
//            }
//        }
//
//        if let last = last {
//
//            if isFirstQuery == true {
//
//                url.append(contentsOf: "last=\(last)")
//                isFirstQuery = false
//            } else {
//                url.append(contentsOf: "&last=\(last)")
//            }
//        }
//
//        return url
//    }
//    
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
