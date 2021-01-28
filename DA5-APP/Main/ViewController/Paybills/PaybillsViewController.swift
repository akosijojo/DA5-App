//
//  PaybillViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class PaybillsViewController: BaseHomeViewControler {
      var headerCell = "headerCell"
      var categoryCellId = "cellId"
      var itemCellId = "cellId2"
      var type : Int? = 0
    
      var viewModel : PaybillsViewModel?
      
      var categories : [CashInData]? {
         didSet {
             self.collectionView.reloadData()
         }
      }

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
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerCell)
        collectionView.register(PaybillsHorizontalCollectionCell.self, forCellWithReuseIdentifier: categoryCellId)
        collectionView.register(PaybillsCell.self, forCellWithReuseIdentifier: itemCellId)
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


extension PaybillsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? HeaderCell else {
             return UICollectionReusableView()
         }
        header.headerView.title.text = "Pay bills"
        header.headerView.desc.text = "Select your payment below"
    
         return header
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.width, height:section == 0 ? 100 : 0)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as? PaybillsHorizontalCollectionCell else {
                return UICollectionViewCell()
            }
            cell.data = [ "ITS A CATEGORY HAHAHHHH", "daiwdhaoiwd", "dgawuidawud", "awudgiuawgdi"]
            cell.delegate = self
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as? PaybillsCell else {
                return UICollectionViewCell()
            }
            cell.data = "Sample ITEM ON CELLL AWDWADAWDAWDWDAD"
            cell.delegate = self
            cell.index = indexPath.item
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("SECTION : \(indexPath.section)")
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        return CGSize(width: collectionView.frame.width - 40 , height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
}

//
extension PaybillsViewController : PaybillsHorizontalCollectionCellDelegate, PaybillsCellDelegate {
    func onClickShowView(cell: PaybillsHorizontalCollectionCell, index: Int) {
        //MARK: change the data to reload collection
//        self.data = self.categories[index].data
        print("SELECTING CATEGORY")
        self.collectionView.reloadData()
    }
    
    func onClick(cell: PaybillsCell, data: String?) {
        self.coordinator?.showPaybillsSelectedViewController(data: data)
    }
        

}
