//
//  ProfileEditingView.swift
//  KarrotMarketCloneCoding
//
//  Created by 신동훈 on 2022/07/15.
//

import UIKit

final class ReusableSettingProfileView: UIView {
    
    internal let imagePickerView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        
        return imageView
    }()
    internal let cameraIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle.fill")
        imageView.tintColor = .systemGray
        imageView.clipsToBounds = true
        return imageView
    }()
    internal let nicknameTextField: UITextField = {
        let textField = CustomTextField(placeholder: "")
//        textField.text = ""
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
    internal let doneButton: UIButton = {
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
        
        addSubview(imagePickerView)
        setImagePickerViewLayout()
        
        addSubview(cameraIconView)
        setCameraIconViewLayout()
        
        addSubview(nicknameTextField)
        setNicknameTextFieldLayout()
        
        addSubview(guidelineLabel)
        setGuidelineLabelLayout()
        
        addSubview(doneButton)
        setEditingDoneButtonLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImagePickerViewLayout() {
        imagePickerView.anchor(top: safeAreaLayoutGuide.topAnchor, topConstant: 30, width: 150, height: 150)
        imagePickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setCameraIconViewLayout() {
        cameraIconView.anchor(bottom: imagePickerView.bottomAnchor, bottomConstant: 15, trailing: imagePickerView.trailingAnchor, trailingConstant: 15, width: 30, height: 30)
    }
    
    private func setNicknameTextFieldLayout() {
        nicknameTextField.anchor(top: imagePickerView.bottomAnchor, topConstant: 25, leading: self.leadingAnchor, leadingConstant: 18, trailing: self.trailingAnchor, trailingConstant: 10)
    }
    
    private func setGuidelineLabelLayout() {
        guidelineLabel.centerX(inView: self, topAnchor: nicknameTextField.bottomAnchor, topConstant: 12)
    }
    
    private func setEditingDoneButtonLayout() {
        doneButton.anchor(bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 75)
    }
    
    func setupTapGestures(target: UIViewController, selector: Selector) {
        
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        
        imagePickerView.addGestureRecognizer(tapGesture)
        imagePickerView.isUserInteractionEnabled = true
    }
}
