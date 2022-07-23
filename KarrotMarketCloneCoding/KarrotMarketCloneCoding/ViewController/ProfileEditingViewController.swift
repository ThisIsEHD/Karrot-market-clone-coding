//
//  ProfileEditingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/15.
//

import UIKit
import PhotosUI

final class ProfileEditingViewController: UIViewController {
    
    let member = User(id: 1, nickName: "욘두", profileImageUrl: nil)
    let profileEditingView = ProfileEditingView(frame: .zero)
    
    override func loadView() {
        
        view = profileEditingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "프로필 수정"
        profileEditingView.nickNameTextField.delegate = self
        profileEditingView.nickNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        profileEditingView.setupTapGestures(target: self, selector: #selector(touchUpImageView))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupNaviBar()
    }
    
    @objc func touchUpImageView() {
        setupImagePicker()
    }
    
    private func setupNaviBar() {

        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.setBackIndicatorImage(UIImage(systemName: "arrow.left"), transitionMaskImage: nil)
        navigationController?.navigationBar.tintColor = .label
    }
    
    func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        constrainWrongNaming()
    }
    
    func constrainWrongNaming() {
        
        if let nickName = profileEditingView.nickNameTextField.text, nickName != member.nickName {
            
            if nickName.count >= 2 {
                
                profileEditingView.editingDoneButton.isEnabled = true
                profileEditingView.editingDoneButton.backgroundColor = UIColor.appColor(.carrot)
            }
        } else {
            
            profileEditingView.editingDoneButton.isEnabled = false
            profileEditingView.editingDoneButton.backgroundColor = UIColor.systemGray
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileEditingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        if finalText.count > 12 {
            return false
        }
        
        return true
    }
}

extension ProfileEditingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.profileEditingView.imagePickerView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}

