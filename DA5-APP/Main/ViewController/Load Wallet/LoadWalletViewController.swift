//
//  LoadWalletViewController.swift
//  DA5-APP
//
//  Created by Jojo on 12/17/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class LoadWalletViewController: BaseHomeViewControler {
      var headerCell = "headerCell"
      var cellId = "cellId"
      var type : Int? = 0
      
      var data : [CashInData]? {
          didSet {
              self.collectionView.reloadData()
          }
      }
    
      lazy var collectionView : UICollectionView = {
          let layout = UICollectionViewFlowLayout()
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
        collectionView.register(LoadWalletCell.self, forCellWithReuseIdentifier: cellId)
        setUpView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    func getData() {
        self.data = [
            CashInData(id: 1, name: "Western Union", image: "western"),
            CashInData(id: 5, name: "DA5", image: "app_logo"),
//            NewsData(id: 3, name: "Western", image: "western"),
//            NewsData(id: 4, name: "Western", image: "western"),
        ]
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


extension LoadWalletViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? LoadWalletHeaderCell else {
             return UICollectionReusableView()
         }
        if self.type == 1 {
            header.headerView.title.text = "Cash Out"
            header.headerView.desc.text = "Choose your preferred cash-out method"
        }
         return header
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.width, height:100)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? LoadWalletCell else {
            return UICollectionViewCell()
        }
        cell.data = self.data?[indexPath.item]
        cell.delegate = self
        cell.index = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width - 60) / 2) , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
}


extension LoadWalletViewController : LoadWalletCellDelegate {
    func onClickItem(cell: LoadWalletCell, index: Int) {
        print("CLICKING : \(type)")
        self.coordinator?.showCashInViewController(data: self.data?[index],type: type)
    }
    
}
