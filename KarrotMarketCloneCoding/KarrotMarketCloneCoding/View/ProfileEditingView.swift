//
//  ProfileEditingView.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/15.
//

import UIKit

class ProfileEditingView: UIView {
    
    internal lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: .zero)
        navigationBar.barTintColor = .systemBackground
        navigationBar.setItems([navigationItem], animated: true)
        
        return navigationBar
    }()
    
    let navigationItem = UINavigationItem(title: "프로필 수정")
    
    internal let imagePickerView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        
        return imageView
    }()
    internal let cameraIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "camera")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    internal let nickNameTextField: UITextField = {
        let textField = CustomTextField(placeholder: "")
        textField.text = "욘두"
        textField.textAlignment = .center
        
        return textField
    }()
    private let guidelineLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 사진과 닉네임을 입력해주세요."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .systemGray
        
        return label
    }()
    internal let editingDoneButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemGray
        button.isEnabled = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(navigationBar)
        setNavigationBar()
        
        addSubview(imagePickerView)
        setImagePickerViewLayout()
        
        addSubview(cameraIconView)
        setCameraIconViewLayout()
        
        addSubview(nickNameTextField)
        setNickNameTextFieldLayout()
        
        addSubview(guidelineLabel)
        setGuidelineLabelLayout()
        
        addSubview(editingDoneButton)
        setEditingDoneButtonLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigationBar() {
        navigationBar.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 50)
        
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setImagePickerViewLayout() {
        imagePickerView.anchor(top: navigationBar.bottomAnchor  , topConstant: 30, width: 150, height: 150)
        imagePickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setCameraIconViewLayout() {
        cameraIconView.anchor(bottom: imagePickerView.bottomAnchor, bottomConstant: 10, trailing: imagePickerView.trailingAnchor, trailingConstant: 10, width: 30, height: 30)
    }
    
    private func setNickNameTextFieldLayout() {
        nickNameTextField.anchor(top: imagePickerView.bottomAnchor, topConstant: 25, leading: self.leadingAnchor, leadingConstant: 18, trailing: self.trailingAnchor, trailingConstant: 10)
    }
    
    private func setGuidelineLabelLayout() {
        guidelineLabel.centerX(inView: self, topAnchor: nickNameTextField.bottomAnchor, topConstant: 12)
    }
    
    private func setEditingDoneButtonLayout() {
        editingDoneButton.anchor(bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 75)
    }
}
