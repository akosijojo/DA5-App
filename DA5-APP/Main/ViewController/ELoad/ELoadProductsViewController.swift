//
//  ELoadProductsViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/5/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class ELoadProductsViewController: BaseHomeViewControler {
    var headerCell = "headerCell"
    var cellId = "cellId"
    var type : Int? = 0
    
    var viewModel : ELoadViewModel?
    
    var phone: String? = ""
    var data : [ELoadProducts?] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.bounces = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = ColorConfig().white
       return v
    }()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LoadWalletHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerCell)
        collectionView.register(ELoadProductsCell.self, forCellWithReuseIdentifier: cellId)
        setUpView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
  
    init(data: [ELoadProducts?],phone: String?) {
        self.data = data
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() {
    
    }
  
    override func setUpView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        })
    }
}


extension ELoadProductsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? LoadWalletHeaderCell else {
             return UICollectionReusableView()
         }
         header.headerView.title.text = "Load Products"
         header.headerView.desc.text = "Select a product to be loaded"
        
         return header
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.width, height:100)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ELoadProductsCell else {
            return UICollectionViewCell()
        }
        cell.data = self.data[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: 60)
    }
}

extension ELoadProductsViewController : ELoadProductsCellDelegate {
    func onClick(cell: ELoadProductsCell, data: ELoadProducts?) {
        if data?.minAmount != data?.maxAmount {
            self.coordinator?.ShowELoadRegularViewController(data: data, phone: phone)
        }else {
            var product = data
            product?.minAmount = "PHP \(data?.minAmount ?? "0").00"
            self.coordinator?.ShowELoadProductDetailsViewController(data: product, phone: phone)
        }
    }
    
    
}
