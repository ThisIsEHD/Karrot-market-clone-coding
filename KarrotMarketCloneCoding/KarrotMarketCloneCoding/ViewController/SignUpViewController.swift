//
//  SignUpViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import Foundation
import UIKit
import Alamofire

final class SignUpViewController: UIViewController {
    
    let signUpView = ReusableSignView(frame: .zero)
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.emailTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        
        signUpView.signButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        setupNaviBar()
    }
    
    @objc func signUp() {
        guard let email = signUpView.emailTextField.text else { return }
        guard let password = signUpView.passwordTextField.text else { return }

//        Network.shared.register(user: User(id: nil, email: email, pw: password, nickName: "브라이언5", name: "신동훈", phone: "010-0000-0018", profileImageUrl: nil))
        
        let url = "http://ec2-43-200-120-225.ap-northeast-2.compute.amazonaws.com/api/v1/users"
        let header: HTTPHeaders = ["Content-Type" : "multipart/form-data"]

        guard let json = try? JSONEncoder().encode(User(id: nil, email: email, pw: password, nickName: "브라이언2", name: "신동명", phone: "010-0000-0013", profileImageUrl: nil)) else { return }
        AF.upload(multipartFormData: { multiData in
            multiData.append(json, withName: "json")
            if let image = UIImage(named: "logo")?.jpegData(compressionQuality: 0.5) {
                multiData.append(image, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
            }
        }, to: URL(string: url)!, usingThreshold: UInt64.init(), method: .post, headers: header).response  { response in
            if let err = response.error {
                print("🛑",err)
                return
            }
            if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                print("success")
                guard let data = response.data, let jsonData = String(data: data, encoding: String.Encoding.utf8) else { return }
                print(jsonData)

            } else if let data = response.data {
                let json = data.toDictionary()
                print(response.response?.statusCode as Any)
                print("Register Failure Response: \(json)")
            }
        }

        navigationController?.popViewController(animated: true)
    }
    
    private func setupNaviBar() {

        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.left"), transitionMaskImage: nil)
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backBarButtonItem?.title = "dk"
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signUpView.emailTextField {
            signUpView.passwordTextField.becomeFirstResponder()
        } else {
            signUp()
        }
        return true
    }
}
