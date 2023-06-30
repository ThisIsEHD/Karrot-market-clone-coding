//
//  SellItemTableViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 4/21/23.
//

import UIKit

// domb: sales 상태마다 테이블뷰 목록을 바꾸고 분기처리

class SalesItemViewController: UIViewController {
    // MARK: - Properties
    
    var viewModel = SalesViewModel()

    private let salesTabCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = false
        collectionView.register(SalesItemCollectionViewCell.self, forCellWithReuseIdentifier: SalesItemCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let underLine = UIView()
    private let salesTabButton = UIButton()
    private let soldTabButton = UIButton()
    private let hiddenTabButton = UIButton()
    private let buttonStackView = UIStackView()
    private var selectedButton: UIButton?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        salesTabButton.isSelected = true
        selectedButton = salesTabButton
        
        configureViews()
        setupCollectionView()
    }
    
    // MARK: - Actions
    
    @objc func tabButtonTapped(_ sender: UIButton) {
        
        guard let selectedButton = selectedButton, selectedButton != sender else { return }
        
        switch sender {
        case salesTabButton:
 
            underLine.snp.remakeConstraints { make in
                make.height.equalTo(2)
                make.width.equalTo(100)
                make.bottom.equalTo(buttonStackView)
                make.centerX.equalTo(salesTabButton)
            }

            salesTabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        case soldTabButton:

            underLine.snp.remakeConstraints { make in
                make.height.equalTo(2)
                make.width.equalTo(100)
                make.bottom.equalTo(buttonStackView)
                make.centerX.equalTo(soldTabButton)
            }

            salesTabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .centeredHorizontally, animated: true)
        case hiddenTabButton:
            
            underLine.snp.remakeConstraints { make in
                make.height.equalTo(2)
                make.width.equalTo(100)
                make.bottom.equalTo(buttonStackView)
                make.centerX.equalTo(hiddenTabButton)
            }

            salesTabCollectionView.scrollToItem(at: IndexPath(item: 0, section: 2), at: .centeredHorizontally, animated: true)
        default:
            return
        }
        
        self.selectedButton = sender
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            sender.isSelected = true
            [self.salesTabButton, self.soldTabButton, self.hiddenTabButton].filter({ button in
                button != sender
            }).forEach { button in
                button.isSelected = false
            }
        }
    }
    
    // MARK: - Configure Views
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(buttonStackView)
        view.addSubview(salesTabCollectionView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        salesTabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        setupButtonStackView()
    }
    
    private func setupButtonStackView() {
        
        buttonStackView.backgroundColor = .white
        buttonStackView.alignment = .fill
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 0
        
        setupButtons()
    }
    
    private func setupButtons() {
        buttonStackView.addArrangedSubview(salesTabButton)
        buttonStackView.addArrangedSubview(soldTabButton)
        buttonStackView.addArrangedSubview(hiddenTabButton)
        
        salesTabButton.setTitle("판매중", for: .normal)
        salesTabButton.setTitle("판매중", for: .selected)
        salesTabButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        salesTabButton.setTitleColor(.systemGray3, for: .normal)
        salesTabButton.setTitleColor(.black, for: .selected)
        salesTabButton.addTarget(self, action: #selector(tabButtonTapped), for: .touchUpInside)
        
        soldTabButton.setTitle("거래완료", for: .normal)
        soldTabButton.setTitle("거래완료", for: .selected)
        soldTabButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        soldTabButton.setTitleColor(.systemGray3, for: .normal)
        soldTabButton.setTitleColor(.black, for: .selected)
        soldTabButton.addTarget(self, action: #selector(tabButtonTapped), for: .touchUpInside)
        
        hiddenTabButton.setTitle("숨김", for: .normal)
        hiddenTabButton.setTitle("숨김", for: .selected)
        hiddenTabButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        hiddenTabButton.setTitleColor(.systemGray3, for: .normal)
        hiddenTabButton.setTitleColor(.black, for: .selected)
        hiddenTabButton.addTarget(self, action: #selector(tabButtonTapped), for: .touchUpInside)
        
        setupUnderLineOfTopView()
    }
    
    private func setupUnderLineOfTopView() {
        buttonStackView.addSubview(underLine)
    
        underLine.backgroundColor = .black
        underLine.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(100)
            make.bottom.equalTo(buttonStackView)
            make.centerX.equalTo(salesTabButton)
        }
    }
    
    private func setupCollectionView() {
        
        salesTabCollectionView.dataSource = self
        salesTabCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension SalesItemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesItemCollectionViewCell.identifier, for: indexPath) as? SalesItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            cell.fetchSellItems(isHide: false, salesState: nil)
        case 1:
            cell.fetchSellItems(isHide: false, salesState: .COMPLETE)
        case 2:
            cell.fetchSellItems(isHide: true, salesState: nil)
        default:
            break
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = salesTabCollectionView.frame.height
        let width = salesTabCollectionView.frame.width
        
        return CGSize(width: width, height: height)
    }
}

extension SalesItemViewController: ItemFetchable {
    func fetchItem(isHide: Bool?, salesState: SalesState?) async -> Result<FetchedItemListData, KarrotError> {
        let result = await viewModel.fetchSalesItems(isHide: isHide, salesState: salesState)
        return result
    }
}
