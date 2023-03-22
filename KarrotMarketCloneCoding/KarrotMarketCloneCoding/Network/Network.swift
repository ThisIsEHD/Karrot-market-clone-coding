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
    case unknownUserOrItem
    case wrongForm([String : String])
    case alreadyWished
    case userIdMismatchWithToken
    
    case notServerError(String)
    case unknownError
    case serverError
}

struct Network {
    
    static let shared = Network()
    
    // MARK: - User API
    
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
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 422:
                    guard let data = response.data else { return }
                    
                    let user = jsonDecode(type: User.self, data: data)
                    
                    if user?.email != nil {
                        completion(.failure(.duplicatedEmail))
                    } else if user?.nickname != nil { completion(.failure(.duplicatedNickname))
                    } else {
                        completion(.failure(.unknownError))
                    }
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func fetchUser(id: String, completion: @escaping (Result<User,KarrotError>) -> Void) {
        
        AF.request(Purpose.fetchUser(id)).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let user = jsonDecode(type: User.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(user))
                case 401:
                    completion(.failure(.invalidToken))
                case 403, 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func updateUserProfile(nickname: String?, image: UIImage?, completion: @escaping (Result<Data?,KarrotError>) -> Void) {
        /// domb: 멸린말치 api 수정후 반영
        ///
        let imageUrl = "이미지 파일로 대체해야함."
        let user = User(nickname: nickname, profileImageUrl: imageUrl)
        
        AF.request(Purpose.update(user)).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    completion(.success(.none))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.invalidToken))
                case 403, 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func deleteUser(completion: @escaping (KarrotError?) -> Void) {
        AF.request(Purpose.deleteUser(UserDefaults.standard.object(forKey: Const.userId) as? String ?? "")).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    completion(nil)
                case 401:
                    completion(.invalidToken)
                case 403, 404:
                    completion(.unknownUserOrItem)
                default:
                    completion(.unknownError)
            }
        }
        
        ///domb: 여기만 Result타입을 쓰지않았음.
    }
    
    func login(email: String?, pw: String?, completion: @escaping (Result<Data?,KarrotError>) -> Void) {
        
        let user = User(email: email, pw: pw)
        
        AF.request(Purpose.login(user)).response { response in
            if let _ = response.error {    /// 응답 에러
                completion(.failure(.serverError))
            }
            ///domb: 여기서 에러는 status error랑 다른것인지 궁금하군
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let token = httpResponse.allHeaderFields["Authorization"] as? String else {
                        let message = "Error: token isn't exist in HeaderFields, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    
                    do {
                        let jwt = try decode(jwt: token)
                        print("jwt: ", jwt)
                        
                        guard let id = jwt.body["user_id"] else {
                            let message = "Error: not found user_id in jwt, Error Point: \(#function)"
                            completion(.failure(.notServerError(message)))
                            return
                        }
                        /// 혹시 모를 상황에 대비하여 한번더 로컬저장소에 저장한 userId를 제거

                        UserDefaults.standard.removeObject(forKey: Const.userId)
                        UserDefaults.standard.set(id, forKey: Const.userId)
                        KeyChain.create(key: id as! String, token: token)
                        
                        completion(.success(.none))
                    }
                    
                    catch {
                        let message = "Error: jwt decode error, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                    }
                    
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.wrongPassword))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func fetchUserSellingItems(of userId: ID, lastId: Int? = nil, size: Int? = nil, completion: @escaping (Result<FetchedItemsList?, KarrotError>) -> Void) {
        
        var queryItems = [String: Any]()
        
        if let size = size {
            queryItems["size"] = size
        }
        
        if let lastId = lastId {
            queryItems["last"] = lastId
        }
        
        AF.request(Purpose.fetchUserSellingItems(userId, queryItems)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let list = jsonDecode(type: FetchedItemsList.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(list))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func registerItem(item: Item, images: [UIImage], completion: @escaping (Result<Data?,KarrotError>) -> ()) {
        
        guard let userId = item.userId else {
            let message = "Error: UserId isn't exist in item, Error Point: \(#function)"
            completion(.failure(.notServerError(message)))
            return
        }
        
        AF.upload(multipartFormData: { data in
            
            guard let jsonData = try? JSONEncoder().encode(item) else {
                let message = "Error: jsonEecoding failure, Error Point: \(#function)"
                completion(.failure(.notServerError(message)))
                return
            }
            
            data.append(jsonData, withName: "json")
            if images.count != 0 {
                for image in images {
                    data.append(image.jpegData(compressionQuality: 0.2)!, withName: "files", fileName: "files")
                }
            }
        }, with: Purpose.registerItem(userId, item)).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 201:
                    completion(.success(.none))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else { fatalError() }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.invalidToken))
                case 403:
                    completion(.failure(.invalidToken))
                case 422:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func fetchUserWishItems(of userId: ID, lastId: Int? = nil, size: Int? = nil, completion: @escaping (Result<FetchedItemsList?, KarrotError>) -> Void) {
        
        var queryItems = [String: Any]()
        
        if let size = size {
            queryItems["size"] = size
        }
        
        if let lastId = lastId {
            queryItems["last"] = lastId
        }
        
        AF.request(Purpose.fetchUserWishItems(userId, queryItems)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let list = jsonDecode(type: FetchedItemsList.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(list))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 403:
                    completion(.failure(.unknownUserOrItem))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func addWishItem(productId: ProductID, of userID: ID, completion: @escaping (Result<Data?, KarrotError>) -> Void) {
        AF.request(Purpose.addWishItem(productId, userID)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    completion(.success(.none))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.invalidToken))
                case 403:
                    completion(.failure(.alreadyWished))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    print(httpResponse.statusCode)
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func deleteWishItem(productId: ProductID, of userID: ID, completion: @escaping (Result<Data?, KarrotError>) -> Void) {
        AF.request(Purpose.deleteWishItem(productId, userID)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    completion(.success(.none))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.invalidToken))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    print(httpResponse.statusCode)
                    completion(.failure(.unknownError))
            }
        }
    }
    
    /// put: 물품의 정보수정
    /// delete: 물품 삭제
    
    // MARK: - Product API
    
    func fetchItems(keyword: String?, category: Int?, sort: String?, lastId: Int? = nil, size: Int? = nil, completion: @escaping (Result<FetchedItemsList?, KarrotError>) -> ()) {
        
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
        
        if let size = size {
            queryItems["size"] = size
        }
        
        AF.request(Purpose.fetchItems(queryItems)).response { response in
            if let err = response.error {
                print(err)
                completion(.failure(.serverError))
                return
            }
            ///여기서 에러는 status error랑 다른것인가?
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let list = jsonDecode(type: FetchedItemsList.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(list))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func fetchItem(userId: ID, productId: ProductID, completion: @escaping (Result<Item?, KarrotError>) -> Void) {
        
        AF.request(Purpose.fetchItem(userId,productId)).response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let list = jsonDecode(type: Item.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(list))
                default:
                    let message = response.data?.toDictionary()
                    completion(.failure(.unknownError))
            }
        }
    }
    
    // MARK: - Chats
    
    func fetchAllChatrooms(id: UserId, lastId: Int? = nil, size: Int? = nil, completion: @escaping (Result<[Chat]?, KarrotError>) -> Void) {
        
        var queryItems = [String : Any]()
        
        if let lastId = lastId {
            queryItems["last"] = lastId
        }
        
        if let size = size {
            queryItems["size"] = size
        }
        
        AF.request(Purpose.fetchAllChats(id, queryItems)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let chatList = jsonDecode(type: ChatList.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(chatList.chat))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.invalidToken))
                case 403:
                    completion(.failure(.userIdMismatchWithToken))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func fetchItemChatroom(id: UserId, chatroomId: ChatroomId, completion: @escaping (Result<Chat, KarrotError>) -> Void) {
        AF.request(Purpose.fetchItemChatroom(id, chatroomId)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let chat = jsonDecode(type: Chat.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(chat))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.invalidToken))
                case 403:
                    completion(.failure(.userIdMismatchWithToken))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    func fetchMyItemChats(id: UserId, chatroomId: ChatroomId, completion: @escaping (Result<[Chat]?, KarrotError>) -> Void) {
        AF.request(Purpose.fetchMyItemChats(id, chatroomId)).response { response in
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let chatList = jsonDecode(type: ChatList.self, data: data) else {
                        let message = "Error: response Data is nil or jsonDecoding failure, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(chatList.chat))
                case 400:
                    guard let message = response.data?.toDictionary() as? [String: String] else {
                        let message = "Error: Can't convert response Data to Dictionary, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.failure(.wrongForm(message)))
                case 401:
                    completion(.failure(.invalidToken))
                case 403:
                    completion(.failure(.userIdMismatchWithToken))
                case 404:
                    completion(.failure(.unknownUserOrItem))
                default:
                    completion(.failure(.unknownError))
            }
        }
    }
    
    // MARK: - Helpers
    
    func fetchImage(url: String, completion: @escaping (Result<UIImage?, KarrotError>) -> Void) {
        AF.request(url).validate().response { response in
            
            guard let httpResponse = response.response else { return }
            
            switch httpResponse.statusCode {
                case 200:
                    guard let data = response.data, let image = UIImage(data: data) else {
                        let message = "Error: response Data is nil, Error Point: \(#function)"
                        completion(.failure(.notServerError(message)))
                        return
                    }
                    completion(.success(image))
                default:
                    completion(.failure(.unknownError))
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

