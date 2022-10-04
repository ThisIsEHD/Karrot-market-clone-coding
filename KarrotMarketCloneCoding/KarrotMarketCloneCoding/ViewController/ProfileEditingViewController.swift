//
//  ProfileEditingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/15.
//

import UIKit
import PhotosUI

class ProfileEditingViewController: UIViewController {
    
    // profile update기능
    
    let profileEditingView = ReusableSettingProfileView(frame: .zero)
    var originNickname: String?
    
    private var profileImage: UIImage? {
        willSet {
            profileEditingView.imagePickerView.image = newValue
            navigationItem.rightBarButtonItem?.isEnabled = profileImage != newValue ? true : false
        }
    }
    
    override func loadView() {
        
        view = profileEditingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "프로필 수정"
        
        profileEditingView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        profileEditingView.setupTapGestures(target: self, selector: #selector(touchUpImageView))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem?.isEnabled = false
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
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if originNickname != sender.text {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func close() {
        Network.shared.updateUserProfile(nickname: profileEditingView.nicknameTextField.text, image: profileImage) { result in
            switch result {
                case .success(_):
                    print("update success")
                case .failure(let error):
                    print(#function, error)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileEditingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.profileImage = image as? UIImage
                    self.profileEditingView.cameraIconView.isHidden = true
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}
