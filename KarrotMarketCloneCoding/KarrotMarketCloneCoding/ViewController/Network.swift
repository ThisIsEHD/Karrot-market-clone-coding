//
//  Network.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 2022/07/25.
//

import Foundation
import Alamofire

struct Network {
    
    static let shared = Network()
    // EHD: 네트워크 함수 구현
    // fetch(Merchandise)
    // post(Merchandise)
    // fetch(User)
    // register(User)
    // url  string으로 ㅅ하지않고 enum으로 구현
    
    
    
    // 엑세스토큰 영구저장소에 저장 및 불러오기
    //
    let url = "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com/api/v1/users"

    let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
    
    func UserUpload(user: User) {
        AF.upload(multipartFormData: { multipartformData in
            if let imageData = UIImage(named: "defaultProfileImage")?.jpegData(compressionQuality: 1) {
                multipartformData.append(imageData, withName: "file", fileName: "profileImage.png", mimeType: "profileImage.png")
            }
            
            let jsonData = try? JSONEncoder().encode(user)
            
            if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                multipartformData.append(jsonData, withName: "json")
            }
            
        }, to: url, headers: header).response { response in
            print(response)
            
            if let err = response.error{    //응답 에러
                print(err)
                return
            }
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print(response.response?.statusCode)
                print("Failure Response: \(json)")
            }
            
            print(response.response?.statusCode)
        }
    }
}
