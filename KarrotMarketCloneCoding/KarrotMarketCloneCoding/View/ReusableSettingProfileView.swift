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
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 40 / 2
        
        return imageView
    }()
    internal let nicknameTextField: UITextField = {
        
        let textField = CustomTextField(placeholder: "")
        
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImagePickerViewLayout() {
        
        imagePickerView.anchor(top: safeAreaLayoutGuide.topAnchor, topConstant: 30, width: 150, height: 150)
        imagePickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setCameraIconViewLayout() {
        
        cameraIconView.anchor(bottom: imagePickerView.bottomAnchor, bottomConstant: 4, trailing: imagePickerView.trailingAnchor, trailingConstant: 4, width: 40, height: 40)
    }
    
    private func setNicknameTextFieldLayout() {
        
        nicknameTextField.anchor(top: imagePickerView.bottomAnchor, topConstant: 25, leading: self.leadingAnchor, leadingConstant: 20, trailing: self.trailingAnchor, trailingConstant: 20)
    }
    
    private func setGuidelineLabelLayout() {
        
        guidelineLabel.centerX(inView: self, topAnchor: nicknameTextField.bottomAnchor, topConstant: 12)
    }
    
    func setupTapGestures(target: UIViewController, selector: Selector) {
        
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        
        imagePickerView.addGestureRecognizer(tapGesture)
        imagePickerView.isUserInteractionEnabled = true
    }
}
