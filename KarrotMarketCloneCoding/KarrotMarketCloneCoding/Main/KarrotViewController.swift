////
////  KarrotViewController.swift
////  KarrotMarketCloneCoding
////
////  Created by 서동운 on 4/6/23.
////
//
//import UIKit
//import Alamofire
//
//class KarrotViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loginIfNeeded()
//    }
//    
//    func loginIfNeeded() {
//        guard let loginCookie = getLoginCookie() else {
//            // User not logged in, show login screen
//            showLoginScreen()
//            return
//        }
//        
//        // User already logged in, use the login cookie for requests
//        
//        var headers = HTTPHeaders()
//        
//        guard let cookies = HTTPCookieStorage.shared.cookies else { fatalError("cookie 없음")}
//        
//        let cookiesHeader = HTTPCookie.requestHeaderFields(with: cookies)
//        
//        for (key, value) in cookiesHeader {
//            headers.add(HTTPHeader(name: key, value: value))
//        }
//        
//        AF.request("https://example.com/api/data", headers: headers).response { response in
//            // Handle response here
//        }
//    }
//    
//    func getLoginCookie() -> HTTPCookie? {
//        let loginCookieName = "my_login_cookie"
//        let cookieStorage = HTTPCookieStorage.shared
//        if let loginCookie = cookieStorage.cookies?.first(where: { $0.name == loginCookieName }) {
//            return loginCookie
//        }
//        return nil
//    }
//    
//    func showLoginScreen() {
//        // Show your login screen UI here
//    }
//    
//    func saveLoginCookie(_ cookie: HTTPCookie) {
//        let cookieStorage = HTTPCookieStorage.shared
//        cookieStorage.setCookie(cookie)
//    }
//    
//    func clearLoginCookie() {
//        let loginCookieName = "my_login_cookie"
//        let cookieStorage = HTTPCookieStorage.shared
//        if let loginCookie = cookieStorage.cookies?.first(where: { $0.name == loginCookieName }) {
//            cookieStorage.deleteCookie(loginCookie)
//        }
//    }
//}
//
//protocol LoginScreenDelegate: AnyObject {
//    func didLogin(with cookie: HTTPCookie)
//    func didLogout()
//}
//
//
//extension KarrotViewController: LoginScreenDelegate {
//    func didLogin(with cookie: HTTPCookie) {
//        saveLoginCookie(cookie)
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func didLogout() {
//        clearLoginCookie()
//        showLoginScreen()
//    }
//}
//
