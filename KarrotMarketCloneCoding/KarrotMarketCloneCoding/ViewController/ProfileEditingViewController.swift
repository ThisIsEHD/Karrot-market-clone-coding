//
//  ProfileEditingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/15.
//

import UIKit
import PhotosUI

//class ProfileEditingViewController: UIViewController {
//
//    // profile update기능
//
//    let profileEditingView = ReusableSettingProfileView(frame: .zero)
//
//    override func loadView() {
//
//        view = profileEditingView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "프로필 수정"
//        tabBarController?.tabBar.isHidden = true
//        profileEditingView.nicknameTextField.delegate = self
//        profileEditingView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        profileEditingView.setupTapGestures(target: self, selector: #selector(touchUpImageView))
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        setupNaviBar()
//    }
//
//    @objc func touchUpImageView() {
//        setupImagePicker()
//    }
//
//    private func setupNaviBar() {
//
//        let appearance = UINavigationBarAppearance()
//
//        appearance.configureWithDefaultBackground()
//        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.left"), transitionMaskImage: nil)
//        navigationController?.navigationBar.tintColor = .label
//    }
//
//    func setupImagePicker() {
//
//        var configuration = PHPickerConfiguration()
//
//        configuration.selectionLimit = 0
//        configuration.filter = .any(of: [.images])
//
//        let picker = PHPickerViewController(configuration: configuration)
//
//        picker.delegate = self
//
//        self.present(picker, animated: true, completion: nil)
//    }
//
//    @objc func textFieldDidChange() {
////        constrainWrongNaming()
//    }
//
//    func constrainWrongNaming() {
//
////        if let nickName = profileEditingView.nickNameTextField.text, nickName != member.nickName {
////
////            if nickName.count >= 2 {
////
////                profileEditingView.editingDoneButton.isEnabled = true
////                profileEditingView.editingDoneButton.backgroundColor = UIColor.appColor(.carrot)
////            }
////        } else {
////
////            profileEditingView.editingDoneButton.isEnabled = false
////            profileEditingView.editingDoneButton.backgroundColor = UIColor.systemGray
////        }
//    }
//
//    @objc func close() {
//        self.dismiss(animated: true, completion: nil)
//    }
//}
//
//extension ProfileEditingViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let currentText = NSString(string: textField.text ?? "")
//        let finalText = currentText.replacingCharacters(in: range, with: string)
//        return finalText.count <= 10
//    }
//}
//
//extension ProfileEditingViewController: PHPickerViewControllerDelegate {
//
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//        picker.dismiss(animated: true)
//
//        let itemProvider = results.first?.itemProvider
//
//        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//
//            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                DispatchQueue.main.async { self.profileEditingView.imagePickerView.image = image as? UIImage }
//            }
//        } else {
//            print("이미지 못 불러왔음!!!!")
//        }
//    }
//}
//

final class ProfileEditingViewController: ProfileSettingViewController {
    
    internal var nickName: String?
    override var isImageChanged: Bool {
        willSet {
            profileView.doneButton.isEnabled = true
            profileView.doneButton.backgroundColor = UIColor.appColor(.carrot)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(isImageChanged)
        profileView.nicknameTextField.delegate = self
        tabBarController?.tabBar.isHidden = true
        profileView.nicknameTextField.text = nickName
        profileView.imagePickerView.image = profileImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func doneButtonTapped() {
//        api 업데이트 후 수정로직 구현
    }
    
    private func enableDoneButton() {
        profileView.doneButton.isEnabled = true
        profileView.doneButton.backgroundColor = UIColor.appColor(.carrot)
    }
    
    private func disableDoneButton() {
        profileView.doneButton.isEnabled = false
        profileView.doneButton.backgroundColor = .systemGray
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        if finalText.count > 0 && finalText != nickName {
            enableDoneButton()
        } else {
            if isImageChanged { enableDoneButton() } else { disableDoneButton() }
        }
        
        
        return finalText.count <= 10
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        if let text = textField.text {
            if text.count > 0 && text != nickName {
                enableDoneButton()
            } else {
                if isImageChanged { enableDoneButton() } else { disableDoneButton() }
            }
        } else {
            if isImageChanged { enableDoneButton() } else { disableDoneButton() }
        }
    }
}
