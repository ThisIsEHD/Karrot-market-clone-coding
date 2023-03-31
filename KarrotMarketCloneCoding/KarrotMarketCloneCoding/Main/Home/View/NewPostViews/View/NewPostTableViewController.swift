//
//  NewPostTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit
import PhotosUI
import Alamofire

final class NewPostTableViewController: UIViewController {
    
    private let newPostViewModel = NewPostViewModel()
    
    private var selectedImages: [UIImage] = [UIImage]() {
        didSet {
            maxChoosableImages = 10 - selectedImages.count
            newPostTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    private var item = Item() {
        didSet {
            if item.preferPlace?.alias != nil {
                newPostTableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
            }
        }
    }
    
    internal var maxChoosableImages = 10
    internal var doneButtonTapped: () -> () = { }
    
    private let newPostTableView = NewPostTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(newPostTableView)
        
        newPostTableView.delegate = self
        newPostTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeImage), name: .imageRemoved, object: nil)
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
        title = "중고거래 글쓰기"
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(post))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.appColor(.carrot)
    }
    
    private func setupNewPostTableView() {
        
        newPostTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = maxChoosableImages
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
            selectedImages.remove(at: indexPath.item - 1)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        view.endEditing(true)
        
        if item.title == nil || item.title == "" {
            let alert = SimpleAlertController(message: "제목을 입력해주세요.")
            present(alert, animated: true)
            return
        }
        
        if item.category == nil {
            let alert = SimpleAlertController(message: "카테고리를 선택해주세요.")
            present(alert, animated: true)
            return
        }
        
        if item.content == nil || item.content == "" {
            let alert = SimpleAlertController(message: "내용을 입력해주세요.")
            present(alert, animated: true)
            return
        }
        
        newPostViewModel.registerItem(item: item, images: selectedImages) { result in
            switch result {
            case .success:
                self.dismiss(animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension NewPostTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        } else {
            return UITableView.automaticDimension
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
            cell.textChanged = { self.item.title = $0 }
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath)
    
            cell.textLabel?.text = "카테고리 선택"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.identifier, for: indexPath) as! PriceTableViewCell
    
            cell.selectionStyle = .none
            cell.textChanged = { self.item.price = Int($0 ?? "0") ?? 0 }
            
            return cell
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
            
            cell.delegate = self
            cell.selectionStyle = .none
            cell.textChanged = { self.item.content = $0 }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationSelectTableViewCell.identifier, for: indexPath) as!
                    LocationSelectTableViewCell
            
            cell.textLabel?.text = "거래 희망 장소"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.location = item.preferPlace?.alias
            
            return cell
        }
    }
}

extension NewPostTableViewController: TableViewCellDelegate {
    func updateTextViewHeight(_ cell: ContentTableViewCell, _ textView: UITextView) {
        let height = textView.bounds.size.height > 120 ? textView.bounds.size.height : 120
        let newSize = newPostTableView.sizeThatFits(CGSize(width: textView.bounds.size.width, height: .infinity))
    
        if height != newSize.height {
            UIView.setAnimationsEnabled(false)
            newPostTableView.beginUpdates()
            newPostTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension NewPostTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            
            if let cell = tableView.cellForRow(at: indexPath) as? BasicTableViewCell {
                
                let vc = CategoryTableViewController()
                
                vc.cellTapped = { indexPathRow in

                    cell.textLabel?.text = "\(vc.categories[indexPathRow].translatedKorean)"
                    self.item.category = Category.allCases[indexPathRow]
                    vc.tableView.reloadRows(at: [indexPath], with: .fade)
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if indexPath.row == 5 {
           let mapvVC = MapViewController()
            mapvVC.locationIsSelctedAction = { locationInfo in
                self.item.preferPlace = locationInfo
            }
            mapvVC.modalPresentationStyle = .fullScreen
            present(mapvVC, animated: true)
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
                    
                    DispatchQueue.main.async { self.selectedImages.append((image as? UIImage)!) }
                }
            } else {
                print("이미지 못 불러왔음!!!!")
            }
        }
    }
}
