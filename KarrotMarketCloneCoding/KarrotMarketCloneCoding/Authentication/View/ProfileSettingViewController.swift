//
//  ProfileSettingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/09/25.
//

import Foundation
import UIKit
import PhotosUI

class ProfileSettingViewController: UIViewController {
    
    // 키체인사용 , 임시구현
    private let email: String
    private let password: String
    private let location: LocationInfo
    private var nickname: String?
    
    private var signUpViewModel = AuthenticationViewModel()
    
    private var isAuthForAlbum: Bool?
    internal var isImageChanged = false
    
    internal var profileImage: UIImage? {
        willSet {
            profileView.imagePickerView.image = newValue == nil ? UIImage(systemName: "person.crop.circle.fill") : newValue
        }
    }
    
    internal let profileView = ReusableSettingProfileView(frame: .zero)
    
    init(email: String, password: String, location: LocationInfo) {
        self.email = email
        self.password = password
        self.location = location

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.nicknameTextField.delegate = self
        profileView.nicknameTextField.placeholder = "닉네임"
        profileView.setupTapGestures(target: self, selector: #selector(touchUpImageView))
        profileView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func touchUpImageView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let selectImageAction = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            self.openAlbum()
        }
        lazy var defaultImageAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { _ in
            
            self.profileImage = nil
            self.isImageChanged = true
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(selectImageAction)
        
        if profileView.imagePickerView.image != nil {
            alert.addAction(defaultImageAction)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    @objc func doneButtonTapped() {
        
        var alert: UIAlertController?
        
        signUpViewModel.signup(user: User(email: email, password: password, nickname: nickname, userLocation: location), profileImage: profileImage) { result in
            switch result {
            case .success:
                self.signIn()
            case .failure(let error):
                switch error {
                default:
                    alert = self.prepareAlert(title: "서버에러. 나중에 다시 시도해주세요.", isPop: false)
                }
                
                self.present(alert!, animated: true)
            }
        }
    }
    
    private func openAlbum() {
        PHPhotoLibrary.requestAuthorization( { status in
            
            switch status {
            case .authorized:
                DispatchQueue.main.async { self.setupImagePicker() }
            case .denied:
                if self.isAuthForAlbum == false { DispatchQueue.main.async { self.AuthSettingOpen() } }
                self.isAuthForAlbum = false
            case .restricted, .notDetermined:
                break
            default:
                break
            }
        })
    }
    
    private func AuthSettingOpen() {

        let message = "📌프로필 사진 변경을\n위해 사진 접근 권한이\n필요합니다"
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let settingAction = UIAlertAction(title: "설정하기", style: .default) { (UIAlertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        
        //alert 사이즈 변경
        let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
        
        alert.view.removeConstraints(widthConstraints)
        
        let newWidth = UIScreen.main.bounds.width * 0.6
        let widthConstraint = NSLayoutConstraint(item: alert.view!,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: newWidth)
        
        alert.view.addConstraint(widthConstraint)
        
        let firstContainer = alert.view.subviews[0]
        let constraint = firstContainer.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        
        firstContainer.removeConstraints(constraint)
        alert.view.addConstraint(NSLayoutConstraint(item: firstContainer,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: alert.view,
                                                    attribute: .width,
                                                    multiplier: 1.0,
                                                    constant: 0))
        
        let innerBackground = firstContainer.subviews[0]
        let innerConstraints = innerBackground.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        
        innerBackground.removeConstraints(innerConstraints)
        firstContainer.addConstraint(NSLayoutConstraint(item: innerBackground,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: firstContainer,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    private func prepareAlert(title: String, isPop: Bool) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
            
            if isPop { DispatchQueue.main.async { self.navigationController?.popViewController(animated: true) } }
        }
        alert.addAction(alertAction)
        
        return alert
    }
    
    private func signIn() {
        signUpViewModel.login(user: User(email: email, password: password)) { result in
            switch result {
            case .success:
                SceneController.shared.login()
            case .failure:
                let alert = self.prepareAlert(title: "서버에러. 나중에 다시 시도해주세요.", isPop: false)

                DispatchQueue.main.async { self.present(alert, animated: true) }
            }
        }
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        profileView.doneButton.isEnabled = finalText.count > 0 ? true : false
        profileView.doneButton.backgroundColor = finalText.count > 0 ? UIColor.appColor(.carrot) : .systemGray
        nickname = textField.text
        
        return finalText.count <= 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension ProfileSettingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                
                DispatchQueue.main.async {
                    self.profileImage = image as? UIImage
                    self.isImageChanged = true
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}
