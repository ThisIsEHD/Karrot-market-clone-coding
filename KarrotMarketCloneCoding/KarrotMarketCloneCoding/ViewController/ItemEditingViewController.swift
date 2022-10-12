//
//  ItemEditingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/17.
//

import UIKit
import PhotosUI
import Alamofire

final class ItemEditingViewController: UIViewController {
    
    private var viewModel = ItemEditingViewModel()
    
    internal var doneButtonTapped: () -> () = { }
    
    
    private let itemEditingView = ItemEditingView(frame: .zero)
    
    convenience init(productID: Int) {
        self.init()
        
        Network.shared.fetchItem(id: productID) { [unowned self] result in
            switch result {
            case .success(let item):
                viewModel.item = item
                itemEditingView.tableView.reloadData()
                item.images?.forEach({ imageInfo in
                    Network.shared.fetchImage(url: imageInfo.url) { [unowned self] result in
                        switch result {
                        case .success(let image):
                            self.viewModel.addImage(image: image!)
                            
                            if imageInfo == item.images?.last {
                                
                                let cell = self.itemEditingView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PhotosSelectingTableViewCell
                                cell?.collectionView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                })
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(itemEditingView)
        
        itemEditingView.tableView.delegate = self
        itemEditingView.tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .systemBackground
        setupNaviBar()
        setupNewPostTableView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNaviBar() {
        title = "중고거래 글쓰기"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(post))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.appColor(.carrot)
    }
    
    private func setupNewPostTableView() {
        
        itemEditingView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        
        guard viewModel.maxChoosableImages != 0 else {
            let alert = SimpleAlert(message: "이미지는 최대 10개까지 첨부할 수 있습니다.")
            self.present(alert, animated: true)
            return
        }
        
        configuration.selectionLimit = viewModel.maxChoosableImages
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

extension ItemEditingViewController {
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        view.endEditing(true)
        
        Network.shared.registerItem(item: viewModel.item, images: viewModel.selectedImages) { result in
            switch result {
            case .success:
                self.doneButtonTapped()
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                var alertMessage = ""
                var completion: ((UIAlertAction) -> ())?
                
                switch error {
                case .wrongForm(let data):

                    if let titleError = data["title"] {
                        alertMessage.append("📌")
                        alertMessage.append(titleError)
                        alertMessage.append("\n")
                    }
                    if let categoryError = data["categoryId"] {
                        alertMessage.append("📌")
                        alertMessage.append(categoryError)
                        alertMessage.append("\n")
                    }
                    if let priceError = data["price"] {
                        alertMessage.append("📌")
                        alertMessage.append(priceError)
                        alertMessage.append("\n")
                    }
                    if let contentError = data["content"] {
                        alertMessage.append("📌")
                        alertMessage.append(contentError)
                    }
                case .invalidToken:
                    alertMessage = "로그인 시간 만료. 다시 로그인 해주세요."
                    completion = { _ in
                        let BackToHome = { self.dismiss(animated: true) }
                        Authentication.goHomeAndLogout(go: BackToHome)
                    }
                case .serverError, .unknownError:
                    alertMessage = "알 수 없는 에러. 나중에 다시 시도해 주세요."
                default:
                    alertMessage = "알 수 없는 에러. 나중에 다시 시도해 주세요."
                }
                
                let alert = completion == nil ?
                SimpleAlert(message: alertMessage) : SimpleAlert(message: alertMessage, completion: completion)
                
                self.present(alert, animated: true)
            }
        }
    }
}

extension ItemEditingViewController: UITableViewDataSource {
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
            
            cell.collectionView.photoPickerCellTapped = { sender in
                self.setupImagePicker()
            }
            viewModel.configureFirst(cell: cell)
            
            return cell
            
        } else if indexPath.row == 1  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
            viewModel.configureSecond(cell: cell)
            cell.textChanged = { title in
                self.viewModel.secondCellDidEndEditing(text: title)
            }
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath) as! BasicTableViewCell
            viewModel.configureThird(cell: cell)
            
            return cell
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.identifier, for: indexPath) as! PriceTableViewCell
            
            viewModel.configureFourth(cell: cell)
            cell.textChanged = { strPrice in
                if let price = strPrice, let intPrice = Int(price) {
                    self.viewModel.fourthCellDidEndEditing(price: intPrice)
                } else {
                    self.viewModel.fourthCellDidEndEditing(price: nil)
                }
            }
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
            
            viewModel.configureFifth(cell: cell)
            cell.textChanged = { description in
                self.viewModel.fifthCellDidEndEditing(description: description)
            }
            
            return cell
        }
    }
}

extension ItemEditingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            
            if let cell = tableView.cellForRow(at: indexPath) as? BasicTableViewCell {
                
                let vc = CategoryTableViewController()
                
                vc.cellTapped = { indexPathRow in
                    
                    self.viewModel.categoryDidTapped(cell: cell, indexPathRow: indexPathRow, in: vc.tableView, at: [indexPath])
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ItemEditingViewController: PHPickerViewControllerDelegate {
//    deinit시 제거해줘야하나?
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)

        results.forEach { result in

            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in

                    DispatchQueue.main.async {
                        self.viewModel.addSelectedImages(image: image as! UIImage)
                        let cell = self.itemEditingView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PhotosSelectingTableViewCell
                        cell?.collectionView.reloadData()
                    }
                }
            } else {
                print("이미지 못 불러왔음!!!!")
            }
        }
    }
}
