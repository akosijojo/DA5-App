//
//  HomeViewController.swift
//  DA5-APP
//
//  Created by Jojo on 8/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class HomeViewController: BaseCollectionViewControler , UICollectionViewDelegateFlowLayout{

    fileprivate let cellId = "cellId"
    fileprivate let cellId2 = "cellId2"
    fileprivate let mainHeaderId = "mainHeaderId"
    fileprivate let headerId = "headerId"
    
    var accountData : AccountData? = AccountData(id: 1, name: "User", image: "user", balance: "1,000,000.00 PHP")
    var servicesData : [ServicesData] = [
        ServicesData(id: 1, name: "Load Wallet", image: "digital-wallet"),
        ServicesData(id: 2, name: "Cash Out", image: "atm"),
        ServicesData(id: 3, name: "Bank Transfer", image: "bank-transfer"),
        ServicesData(id: 4, name: "Wallet transfer", image: "money"),
        ServicesData(id: 5, name: "FX", image: "exchange"),
        ServicesData(id: 6, name: "Pay Bills", image: "bill"),
        ServicesData(id: 7, name: "Load", image: "smartphone"),
        ServicesData(id: 8, name: "Crypto", image: "crypto"),
        ServicesData(id: 9, name: "Loans", image: "communication"),
    ]
    
    var newsData : [NewsData] = [
        NewsData(id: 1, name: "Western", image: "western"),
        NewsData(id: 2, name: "City", image: "img_city"),
        NewsData(id: 3, name: "Western", image: "western"),
        NewsData(id: 4, name: "Western", image: "western"),
    ]
    
    var pTransactionsData : [PendingTransactionsData] = [
        PendingTransactionsData(id: 1, title: "Western", image: "western", amount: "PHP 200.00", date: "April 03, 2020"),
        PendingTransactionsData(id: 1, title: "Western", image: "img_city", amount: "PHP 1000.00", date: "January 01, 2020"),
        PendingTransactionsData(id: 1, title: "Western", image: "western", amount: "PHP 500.00", date: "November 10, 2020"),
    ]
    
    var tHistoryData : [TransactionHistoryData] = [
        TransactionHistoryData(id: 1, title: "CASH IN", info: "Paymaya", image: "western", amount: "PHP 200.00", date: "April 03, 2020"),
        TransactionHistoryData(id: 1, title: "BANK TRANSFER", info: "GCASH", image: "img_city", amount: "PHP 1000.00", date: "January 01, 2020"),
        TransactionHistoryData(id: 1, title: "BUY LOAD", info:"+639123456789", image: "western", amount: "PHP 500.00", date: "November 10, 2020"),
        TransactionHistoryData(id: 1, title: "BUY LOAD", info:"+639123456789", image: "western", amount: "PHP 500.00", date: "November 11, 2020"),
    ]

    var sideMenuView = SideMenuView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        collectionView.backgroundColor = .white
        hidesKeyboardOnTapArround()
        // Do any additional setup after loading the view.
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CollectionViewBorderedCell.self, forCellWithReuseIdentifier: cellId2)
        collectionView.register(HomeHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:mainHeaderId)
        collectionView.register(HeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerId)
       
        // bakit 2x natatawag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    override func setUpView() {
        self.collectionView.addSubview(sideMenuView)
        self.sideMenuView.vc = self
        sideMenuView.frame = self.collectionView.bounds
        
    }
    
    func onClickShowView(type: Int) {
        switch type {
        case 1:
            homeCoordinator?.showBase2ndViewController()
        default: break
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section  == 0 {
              guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: mainHeaderId, for: indexPath) as? HomeHeaderCollectionViewCell else {
                  return UICollectionReusableView()
              }
              header.maintainingBalance.text = self.accountData?.balance
              header.delegate = self
              return header
        }
            
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCollectionViewCell else {
                 return UICollectionReusableView()
             }
        header.label.text = section == 1 ? "Services Available" : section == 2 ?  "News" : section == 3 ?  "Pending Transactions" : "Transaction History"
        if section == 2 {
            header.addAction()
            header.rightBtn.text = "View All"
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:view.frame.width, height: section == 0 ? 240 : 40)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  section == 0 ? 0 : 1
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as? CollectionViewBorderedCell else {return UICollectionViewCell()}
            cell.setUpCollectionView(type: indexPath.section)
            cell.section = indexPath.section
            cell.servicesData = servicesData
            return cell
        case 4 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as? CollectionViewBorderedCell else {return UICollectionViewCell()}
            cell.setUpCollectionView(type: indexPath.section)
            cell.section = indexPath.section
            cell.tHistoryData = tHistoryData
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CollectionViewCell else {return UICollectionViewCell()}
            cell.setUpCollectionView(type: indexPath.section)
            cell.section = indexPath.section
            cell.delegate = self
            if indexPath.section == 2 {
                cell.newsData = newsData
            }else {
                cell.pTransactionsData = pTransactionsData
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let servicesHeight = ((self.servicesData.count / 3) * 95) // cell 80 for 40 + 10 , 20 + 10 , collection top 10 space , left and right 10 , bottom have space 10 
        let newsHeight = 190
        let tHistoryHeight = 80 * (self.tHistoryData.count)
        let vheight = indexPath.section == 1 ? servicesHeight : (indexPath.section == 4 ? tHistoryHeight : newsHeight)
        return CGSize(width: view.frame.width, height: CGFloat(vheight))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: section == 0 ? 0 : 10, right: 0)
    }
}
//MENU
extension HomeViewController : HomeHeaderCollectionViewCellDelegate {
    func onClickMenu(cell: HomeHeaderCollectionViewCell) {
        sideMenuView.updateSideMenu(width: sideMenuView.isShowMenu ? 0 : 250)
    }
}


extension HomeViewController : CollectionViewCellDelegate {
    func onClickShowView(cell: CollectionViewCell, type: Int, data: [String : AnyObject]?) {
        self.homeCoordinator?.showBase2ndViewController()
    }
}
