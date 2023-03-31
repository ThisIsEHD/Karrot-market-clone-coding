//
//  BottomSheetViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/21/23.
//

import UIKit
import SnapKit

class BottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    var doneButtonAction: (String) -> Void = { Alias in }
    
    let label = UILabel()
    let textField = UITextField()
    let button = UIButton()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    // MARK: - Actions
    
    @objc func doneButtonDidTapped() {
        guard let alias = textField.text else { return }
        
        doneButtonAction(alias)
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        view.backgroundColor = .white

        label.text = "선택한 곳의 장소명을 입력해주세요"
        label.numberOfLines = 1
        
        textField.placeholder = "예) 강남역 1번 출구, 당근빌딩 앞"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        button.setTitle("거래 장소 등록", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.titleLabel?.textColor = .black
        button.isEnabled = false
        button.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(button)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(view).inset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.bottom.equalTo(button.snp.top).offset(-10)
            make.height.equalTo(50)
        }
        button.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
}

extension BottomSheetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }

        let newLength = text.count + string.count - range.length
        let maxLength = 20
        
        if string.isEmpty {
            return true
        }
        
        if range.location + range.length <= 20 {
            return newLength <= maxLength
        } else {
            return false
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            button.isEnabled = false
            button.backgroundColor = .gray.withAlphaComponent(0.5)
            button.titleLabel?.textColor = .black
        } else {
            button.isEnabled = true
            button.backgroundColor = .orange
            button.titleLabel?.textColor = .white
        }
    }
}
