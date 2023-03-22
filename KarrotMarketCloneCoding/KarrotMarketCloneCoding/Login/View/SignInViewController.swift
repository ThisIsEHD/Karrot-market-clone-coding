//
//  SignInViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/14.
//

import UIKit

final class SignInViewController: SignUpViewController {
    
    override func configureNextScene() {
        guard let email = RealView.emailTextField.text else { return }
        guard let password = RealView.passwordTextField.text else { return }
        
        var alert: UIAlertController?
        
        Network.shared.login(email: email, pw: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async { self.dismiss(animated: true) }
            case .failure(let error):
                switch error {
                case .wrongPassword:
                    alert = self.prepareAlert(title: "비밀번호를 확인해주세요.", isPop: false)
                case .unknownUserOrItem:
                    alert = self.prepareAlert(title: "일치하는 회원정보가 없습니다.\n회원가입을 먼저 해주세요.", isPop: true)
                case .serverError:
                    alert = self.prepareAlert(title: "서버에러. 나중에 다시 시도해주세요.", isPop: false)
                default:
                    alert = self.prepareAlert(title: "서버에러. 나중에 다시 시도해주세요.", isPop: false)
                }

                DispatchQueue.main.async { self.present(alert!, animated: true) }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealView.helloLabel.text = "안녕하세요!,\n이메일로 로그인해주세요."
        RealView.signButton.setTitle("로그인", for: .normal)
    }
    
    private func prepareAlert(title: String, isPop: Bool) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
            if isPop {
                DispatchQueue.main.async { self.navigationController?.popViewController(animated: true) }
            }
        }
        
        alert.addAction(alertAction)
        
        return alert
    }
}
