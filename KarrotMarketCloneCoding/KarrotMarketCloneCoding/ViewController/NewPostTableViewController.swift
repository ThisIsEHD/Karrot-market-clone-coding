//
//  NewPostTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit
import PhotosUI

final class NewPostTableViewController: UIViewController {
    
    private var selectedImages = [UIImage?]() {
        didSet {
            newPostTableView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    internal var doneButtonTapped: () -> () = { }
    
    private let newPostTableView = NewPostTableView(frame: .zero)
    
    private let navibar = CustomNavigationBar(navigationBarTitle: "중고거래 글쓰기",  leftBarButtonImage: "xmark", leftButtonColor: .label, rightBarButtonTitle: "완료", rightButtonColor: UIColor.appColor(.carrot), lefeButtonAction: #selector(close), rightButtonAction: #selector(post))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(newPostTableView)
        
        newPostTableView.tableView.delegate = self
        newPostTableView.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeImage), name: NotificationType.deleteButtonTapped.name, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        setupNaviBar()
        setupNewPostTableView()
    }
    
    private func setupNaviBar() {
        
        view.addSubview(navibar)
        navibar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: newPostTableView.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupNewPostTableView() {
        
        newPostTableView.anchor(top: self.navibar.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 10
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func handle(keyboardShowNotification notification: Notification) {
        // 1
        print("Keyboard show notification")
        
        // 2
        if let userInfo = notification.userInfo,
            // 3
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.width)
        }
    }
}

extension NewPostTableViewController {
    
    @objc func removeImage(_ notification: NSNotification) {
        
        if let indexPath = notification.userInfo?[UserInfo.indexPath] as? IndexPath {
            selectedImages?.remove(at: indexPath.item - 1)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        Network.shared.registerItem(item: Item(id: nil, title: "", content: "", categoryId: 1, price: 10000, regdate: nil, views: nil, wishes: nil, userId: (UserDefaults.standard.object(forKey: Const.userId.asItIs) as? String), nickname: nil, images: nil), images: selectedImages) { result in
            switch result {
            case .success:
                self.doneButtonTapped()
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension NewPostTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 110
        } else if indexPath.row == 4 {
            
            return UITableView.automaticDimension
        } else {
            
            return 85
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosSelectingTableViewCell.identifier, for: indexPath) as! PhotosSelectingTableViewCell
            
            cell.collectionView.photoPickerCellTapped = { [weak self] sender in
                self?.setupImagePicker()
            }
            
            cell.collectionView.images = selectedImages
            cell.selectionStyle = .none
            cell.clipsToBounds = false
            
            return cell
            
        } else if indexPath.row == 1  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath)
            
            cell.textLabel?.text = "카테고리 선택"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.identifier, for: indexPath) as! PriceTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 999)
            cell.selectionStyle = .none
            cell.descriptionTextView.delegate = newPostTableView
            
            return cell
        }
    }
}

extension NewPostTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        if indexPath.row == 2 {
            
            if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
                
                let vc = CategoryTableViewController()
                
                vc.cellTapped = { sender in
                    
                    cell.textLabel?.text = "\(vc.selectedCategory)"
                    vc.tableView.reloadRows(at: [indexPath], with: .fade)
                }
                navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
}

extension NewPostTableViewController: PHPickerViewControllerDelegate {
//    deinit시 제거해줘야하나?
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)

        results.forEach { result in

            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {

                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    DispatchQueue.main.async { self.selectedImages.append(image as? UIImage) }
                }
            } else {
                print("이미지 못 불러왔음!!!!")
            }
        }
    }
}
