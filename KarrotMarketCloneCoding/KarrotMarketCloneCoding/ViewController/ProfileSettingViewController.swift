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
    
    private var isAuthForAlbum: Bool?
    
    internal var email: String?
    internal var pw: String?
    
    private var profileImage: UIImage? {
        willSet {
            profileView.imagePickerView.image = newValue
        }
    }
    
    private let profileView = ReusableSettingProfileView(frame: .zero)
    
    internal let doneButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemGray
        button.isEnabled = false
        
        return button
    }()
    
    var bottomConstraints: NSLayoutConstraint?
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.nicknameTextField.delegate = self
        profileView.nicknameTextField.placeholder = "닉네임"
        profileView.setupTapGestures(target: self, selector: #selector(touchUpImageView))
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setDoneButtonLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func touchUpImageView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let selectImageAction = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            self.openAlbum()
        }
        lazy var defaultImageAction = UIAlertAction(title: "기본 이미지로 변경", style: .default) { _ in
            self.profileImage = nil
            self.profileView.cameraIconView.isHidden = false
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(selectImageAction)
        
        if profileView.imagePickerView.image != nil {
            alert.addAction(defaultImageAction)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    @objc private func doneButtonTapped() {
        let user = User(email: email, pw: pw, nickname: profileView.nicknameTextField.text)
        
        var alert: UIAlertController?
        Network.shared.register(user: user, image: profileImage) { result in
            
            switch result {
            case .success:
                self.signIn()
            case .failure(let error):
                switch error {
                case .duplicatedEmail:
                    alert = self.prepareAlert(title: "이미 사용중인 이메일입니다.", isPop: true)
                case .duplicatedNickname:
                    alert = self.prepareAlert(title: "이미 사용중인 닉네임입니다.", isPop: false)
                case .serverError:
                    alert = self.prepareAlert(title: "서버 에러. 나중에 다시 시도해주세요.", isPop: false)
                default:
                    alert = self.prepareAlert(title: "서버에러. 나중에 다시 시도해주세요.", isPop: false)
                }
                
                DispatchQueue.main.async { self.present(alert!, animated: true) }
            }
        }
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        bottomConstraints?.isActive = false
        bottomConstraints?.constant = -keyboardHeight
        bottomConstraints?.isActive = true
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        bottomConstraints?.isActive = false
        bottomConstraints?.constant = 0
        bottomConstraints?.isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
        
        Network.shared.auth(email: email, pw: pw) { result in
            switch result {
            case .success:
                DispatchQueue.main.async { self.dismiss(animated: true) }
            case .failure:
                let alert = self.prepareAlert(title: "서버에러. 나중에 다시 시도해주세요.", isPop: false)

                DispatchQueue.main.async { self.present(alert, animated: true) }
            }
        }
    }
    
    private func setDoneButtonLayout() {
        doneButton.anchor(leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, height: 75)
        bottomConstraints = doneButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        bottomConstraints?.isActive = true
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        doneButton.isEnabled = finalText.count > 0 ? true : false
        doneButton.backgroundColor = finalText.count > 0 ? UIColor.appColor(.carrot) : .systemGray
        
        return finalText.count <= 10
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
                    self.profileView.cameraIconView.isHidden = true
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}
