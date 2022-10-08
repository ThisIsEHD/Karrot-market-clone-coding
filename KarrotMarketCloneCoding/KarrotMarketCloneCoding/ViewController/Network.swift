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
    case duplicatedNickname
    case unknownUser
    case wrongForm([String : String])
    
    case unknownError
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
                    else if user?.nickname != nil { completion(.failure(.duplicatedNickname))}
                    else { completion(.failure(.serverError)) }
                default:
                    completion(.failure(.serverError))
            }
        }
    }
    
    func auth(email: String, pw: String, completion: @escaping (Result<Data?,KarrotError>) -> Void) {
        
        let user = User(email: email, pw: pw)
        
        AF.request(Purpose.login(user)).response { response in
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
                        UserDefaults.standard.removeObject(forKey: Const.userId)
                        UserDefaults.standard.set(id, forKey: Const.userId)
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
    
    func fetchItems(keyword: String?, category: Int?, sort: String?, lastId: Int?, completion: @escaping (Result<FetchedItemsList?, KarrotError>) -> ()) {
        
        var queryItems = [String : Any]()
        
        if let keyword = keyword {
            queryItems["keyword"] = keyword
        }
        if let category = category {
            queryItems["category"] = category
        }
        if let sort = sort {
            queryItems["sort"] = sort
        }
        if let lastId = lastId {
            queryItems["last"] = lastId
        }
        
        AF.request(Purpose.fetchItems(queryItems)).response { response in
            if let err = response.error {
                print(err)
                completion(.failure(.serverError))
                return
            }
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                guard let data = response.data else { return }
                
                do {
                    let list = try JSONDecoder().decode(FetchedItemsList.self, from: data)
                    completion(.success(list))
                } catch {
                    print(error)
                    completion(.failure(.serverError))
                }
                
            } else if let data = response.data {
                let json = data.toDictionary()
                
                print("Register Failure Response: \(json)")
                completion(.failure(.serverError))
            }
        }
    }
    
    func fetchItem(id: ProductID, completion: @escaping (Result<Item?, KarrotError>) -> Void) {
        
        AF.request(Purpose.fetchItem(id)).response { response in
            if let err = response.error {
                print(err)
                completion(.failure(.serverError))
                return
            }
            
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                guard let data = response.data else { return }
                
                do {
                    let item = try JSONDecoder().decode(Item.self, from: data)
                    completion(.success(item))
                } catch {
                    print(error)
                    completion(.failure(.serverError))
                }
                
            } else if let data = response.data {
                let json = data.toDictionary()
                
                print("Register Failure Response: \(json)")
                completion(.failure(.serverError))
            }
        }
    }
    
    func registerItem(item: Item, images: [UIImage], completion: @escaping (Result<Data?,KarrotError>) -> ()) {
        
        AF.upload(multipartFormData: { data in
            
            guard let jsonData = try? JSONEncoder().encode(item) else { return }
            
            data.append(jsonData, withName: "json")
            if images.count != 0 {
                for image in images {
                    data.append(image.jpegData(compressionQuality: 0.2)!, withName: "files", fileName: "files")
                }
            }
        }, with: Purpose.registerItem(item.userId ?? "", item)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 201:
                    completion(.success(.none))
                case 400:
                    completion(.failure(.serverError))
                case 401:
                    completion(.failure(.invalidToken))
                case 403:
                    completion(.failure(.invalidToken))
                case 422:
                guard let data = response.data, let dicData = try? JSONSerialization.jsonObject(with: data) as? [String: String]  else { completion(.failure(.serverError)); return }
                
                completion(.failure(.wrongForm(dicData)))
                default:
                    completion(.failure(.serverError))
            }
        }
    }
    
    func fetchImage(url: String, completion: @escaping (Result<UIImage?, KarrotError>) -> Void) {
        AF.request(url).validate().responseData { response in

            if let err = response.error {
                print(err)
                completion(.failure(.serverError))
                return
            }
            
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                guard let data = response.data else { return }
                
                let image = UIImage(data: data)
                completion(.success(image))
            }
        }
    }
    
    func deleteUser(completion: @escaping (KarrotError?) -> Void ) {
        AF.request(Purpose.deleteUser(UserDefaults.standard.object(forKey: Const.userId) as? String ?? "")).response { response in
            
            if let _ = response.error{    //응답 에러
                completion(.serverError)
            }
            guard let httpResponse = response.response else { return }

            switch httpResponse.statusCode {
                case 200:
                    completion(nil)
                case 401:
                    completion(.invalidToken)
                case 403, 404:
                    completion(.unknownUser)
                default:
                    completion(.serverError)
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
}
