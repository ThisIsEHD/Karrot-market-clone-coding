//
//  AppDelegate.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/11.
//

import UIKit
import Firebase
import Alamofire
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 파이어 베이스 초기 설정
        FirebaseApp.configure()
        
        // 클라우드 메세징 대리자 설정
        Messaging.messaging().delegate = self
        
        // push notification 대리자 설정
        UNUserNotificationCenter.current().delegate = self
        
        // push notification option 설정
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                // apns로 부터 push noti를 받도록 설정
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        )
        
        return true
    }
    
    // 디바이스 토큰을 받아서 firebase 클라우드 메세징의 apns 토큰과 매핑
   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 2
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        //        sharedMeetingManager.queueMeetingForDelivery(user: userID, meetingID: meetingID)
        return [.badge, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let request = response.notification.request
        request.identifier
        
        let content = request.content
        content.title
        content.userInfo
        content.body
        content.categoryIdentifier
        content.subtitle
        // 알림 페이로드에 click_action을 사용해도됨?.
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            //                sharedMeetingManager.acceptMeeting(user: userID, meetingID: meetingID)
            break
            
        case "DECLINE_ACTION":
            //                sharedMeetingManager.declineMeeting(user: userID, meetingID: meetingID)
            break
        default:
            break
        }
        
        return
    }
//    {
//       "aps" : {
//          "alert" : {
//             "title" : "Game Request",
//             "subtitle" : "Five Card Draw",
//             "body" : "Bob wants to play poker"
//          },
//          "category" : "GAME_INVITATION"
//       },
//       "gameID" : "12345678"
//    }
    // 백그라운드 업데이트
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

// FCM delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // 1
        // domb: fcm토큰을 먼저 생성하고 기기토큰을 매핑시키는 것으로 보임. 현재 플로우상 앱을 켤때 기기토큰을 매핑하게 되는데 그럼 설정에 들어가서 알림설정을 나중에 하더라도 앱을 켜지 않아도 받을 수 있나??
        guard let fcmToken = fcmToken else {
            return
        }
        
        // fcm토큰 등록시 쿠키가 필요한데 이 시점에서는 사용자가 로그인 후 사용하는 쿠키가 존재하지않음.
        // fcm 토큰을 저장해놨다가 로그인하면 fcm토큰 등록 api를 호출해야하나??
        
//        Task {
//            let response = await AF.request(KarrotRequest.registerFCMToken(fcmToken)).serializingDecodable(KarrotResponse<Bool>.self).response
//            
//            let result = handleResponse(response)
//            
//            switch result {
//            case .success:
//                print("FCM 토큰 서버에 등록 성공")
//                return
//            case .failure(let error):
//                self.presentError(error: error)
//                return
//            }
//        }
        print(fcmToken, #function)
    }
}

extension AppDelegate: ErrorPresentable {
    func presentError(error: KarrotError) {
//        let alert = UIAlertController(title: "Message", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        print(error, #function)
    }
}
