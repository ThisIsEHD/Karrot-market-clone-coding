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
    let realView = ProfileEditingView(frame: .zero)
    
    override func loadView() {
        view = realView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realView.nickNameTextField.delegate = self
        realView.nickNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        setupTapGestures()
        
        realView.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "clear"), style: .plain, target: nil, action: #selector(close))
        realView.navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        realView.imagePickerView.addGestureRecognizer(tapGesture)
        realView.imagePickerView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        
        setupImagePicker()
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
        if let nickName = realView.nickNameTextField.text, nickName != member.nickName {
            if nickName.count >= 2 {
                realView.editingDoneButton.isEnabled = true
                realView.editingDoneButton.backgroundColor = UIColor.appColor(.carrot)
            }
        } else {
            realView.editingDoneButton.isEnabled = false
            realView.editingDoneButton.backgroundColor = UIColor.systemGray
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
                    self.realView.imagePickerView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}

