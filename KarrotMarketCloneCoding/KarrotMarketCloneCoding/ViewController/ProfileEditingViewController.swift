//
//  ProfileEditingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/15.
//

import UIKit
import PhotosUI

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
