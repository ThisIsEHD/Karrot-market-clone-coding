//
//  Network.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/25.
//

import Foundation
import Alamofire

typealias Token = String
typealias UserId = String

struct Network {
    
    static let shared = Network()
    
    func register(user: User) {
        AF.request(Purpose.registerUser(user)).response { response in
            if let err = response.error {
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
    
    func fetch(completion: @escaping (User?) -> Void) {
        AF.request(Purpose.fetchUser, interceptor: MyInterceptor()).response { response in
            if let err = response.error{    //응답 에러
                print(err)
                return
            }
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                print("fetch success")
                guard let data = response.data, let user = try? JSONDecoder().decode(User.self, from: data) else {
                    fatalError()
                }
                completion(user)
                
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
    
    // domb: Date Formatter만 디코딩 가능?
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
