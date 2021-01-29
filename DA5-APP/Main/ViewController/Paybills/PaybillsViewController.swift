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
      
      var activeCategory : CategoryData = .insurance
    
      var categories : [CategoryData]? {
         didSet {
            print("CATEGORY : \(self.categories?[1].rawValue)")
         }
      }

      var data : PaybillsData? {
          didSet {
                self.dataFiltered = self.filterData(from: self.activeCategory, data: self.data?.billers)
          }
      }
    
     var dataFiltered : [BillerData]? {
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
        
        self.viewModel?.onSuccessPaybillsData = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.data = data
                self?.categories = [CategoryData.insurance,CategoryData.government ,CategoryData.electricity ,CategoryData.utilities,CategoryData.others ,CategoryData.cable
                ,CategoryData.water ,CategoryData.telecom ,CategoryData.airlines ,CategoryData.sssContribution ,CategoryData.mobileLoad,CategoryData.realEstate, CategoryData.onlineShopping ]
            }
        }
    
        self.setAnimate(msg: "Please wait...")
        self.viewModel?.getBillers(token: self.coordinator?.token)
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
        return self.dataFiltered?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as? PaybillsHorizontalCollectionCell else {
                return UICollectionViewCell()
            }
            cell.data = self.categories
            cell.delegate = self
            cell.activeCategory = self.activeCategory
            
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as? PaybillsCell else {
                return UICollectionViewCell()
            }
            cell.imageView.image = nil
            cell.data = self.dataFiltered?[indexPath.item]
            cell.delegate = self
            cell.index = indexPath.item
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("SECTION : \(indexPath.section)")
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 35) 
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
    func onClickShowView(cell: PaybillsHorizontalCollectionCell, data: CategoryData) {
        //MARK: change the data to reload collection
//        self.data = self.categories[index].data
        print("SELECTING CATEGORY")
        self.activeCategory = data
        self.dataFiltered = self.filterData(from: data, data: self.data?.billers)
        
    }
    
    func onClick(cell: PaybillsCell, data: BillerData?) {
        if let d = data {
            self.coordinator?.showPaybillsSelectedViewController(data: d)
        }
    }
    
    func filterData(from: CategoryData, data: [BillerData]?) -> [BillerData] {
        var dataFiltered : [BillerData] = []
        if let bData = data {
            for item in bData {
                 if  item.category == from {
                    dataFiltered.append(item)
                }
            }
        }
        return dataFiltered
    }
        

}
