//
//  HomeViewController.swift
//  DA5-APP
//
//  Created by Jojo on 8/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class HomeViewController: BaseCollectionViewControler , UICollectionViewDelegateFlowLayout{

    var token : String = ""
    var isEmpty : Bool = false
    var refreshControl : UIRefreshControl?
    var isRefreshing  : Bool = false
    var viewModel : HomeViewModel?
    fileprivate let cellId = "cellId"
    fileprivate let cellId1 = "cellId1"
    fileprivate let cellId2 = "cellId2"
    fileprivate let cellId3 = "cellId3"
    fileprivate let cellId4 = "cellId4"
    fileprivate let mainHeaderId = "mainHeaderId"
    fileprivate let headerId = "headerId"
    fileprivate let cell = "cell"
    
    var loaded : Bool = false
    
    var customerData : Customer?
    
    var homeData : HomeData? {
        didSet {
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.newsData = self.homeData?.news
                self.pTransactionData = self.homeData?.pendingTransaction
                self.tHistoryData = self.homeData?.transactionHistory
                self.collectionView.reloadData()
            }
        }
    }
    
    var accountData : AccountData? = AccountData(id: 1, name: "User", image: "user", balance: "1,000,000.00 PHP")
    
    var servicesData : [ServicesData] = []
    var newsData : [NewsData]? = []
    var pTransactionData : [PendingTransactionsData]? = []
    var tHistoryData : [TransactionHistoryData]? = []

    var sideMenuView = SideMenuView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
//        collectionView.bounces = false
        collectionView.backgroundColor = .white
        hidesKeyboardOnTapArround()
        // Do any additional setup after loading the view.
        collectionView.register(ServicesCollectionViewCell.self, forCellWithReuseIdentifier: cellId1)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: cellId2)
        collectionView.register(PendingTransactionCollectionViewCell.self, forCellWithReuseIdentifier: cellId3)
        collectionView.register(TransactionHistoryCollectionViewCell.self, forCellWithReuseIdentifier: cellId4)
        
        collectionView.register(HomeHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:mainHeaderId)
        collectionView.register(HeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerId)
        setUpView()
        getData()
        setUpRefreshView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    func setUpRefreshView() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        refreshControl?.attributedTitle = NSAttributedString(string: "Refresh Collection View", attributes: nil)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl!)
        }
    }
    
    @objc func refreshData() {
        print("REFRESHING ? ")
        isRefreshing = true
        self.viewModel?.getHomeData(id: self.customerData?.id ?? 0)
       
    }
    
    override func getData() {
        self.viewModel?.onSuccessGettingList = { [weak self] data in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self?.isRefreshing = false
            self?.refreshControl?.endRefreshing()
                
            self?.homeData = data
            self?.homeData?.news = [
                 NewsData(id: 1, name: "Western", image: "western"),
                 NewsData(id: 2, name: "City", image: "img_city"),
                 NewsData(id: 3, name: "Western", image: "western"),
                 NewsData(id: 4, name: "Western", image: "western"),
            ]
                
//            self?.homeData?.pendingTransaction =  [
//               PendingTransactionsData(id: 1, title: "Western", image: "western", amount: "PHP 200.00", date: "April 03, 2020"),
//               PendingTransactionsData(id: 1, title: "Western", image: "img_city", amount: "PHP 1000.00", date: "January 01, 2020"),
//               PendingTransactionsData(id: 1, title: "Western", image: "western", amount: "PHP 500.00", date: "November 10, 2020"),
//           ]

//            self?.homeData?.transactionHistory = [
//                TransactionHistoryData(id: 1, title: "CASH IN", info: "Paymaya", image: "western", amount: "PHP 200.00", date: "April 03, 2020"),
//                TransactionHistoryData(id: 1, title: "BANK TRANSFER", info: "GCASH", image: "img_city", amount: "PHP 1000.00", date: "January 01, 2020"),
//                TransactionHistoryData(id: 1, title: "BUY LOAD", info:"+639123456789", image: "western", amount: "PHP 500.00", date: "November 10, 2020"),
//                TransactionHistoryData(id: 1, title: "BUY LOAD", info:"+639123456789", image: "western", amount: "PHP 500.00", date: "November 11, 2020"),
//            ]
            
            self?.servicesData = [
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
            //MARK: - REMOVE EMPTY VIEW
            if self?.isEmpty ?? false {
                print("REMOVE EMPTY VIEW")
                self?.collectionView.emptyView(image: "", text: "", dataCount: 1, emptyViewType: .main)
            }
            self?.loaded = true
                
           })

        }
        
        self.viewModel?.onSuccessGenerateToken = { [weak self] data in
            DispatchQueue.main.async {
                self?.coordinator?.token = data?.accessToken
                self?.viewModel?.getHomeData(id: UserLoginData.shared.id ?? 0) //self?.customerData?.id ?? 0
            }
        }
        
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                if status?.tag == 1 {
                    self?.isRefreshing = false
                    self?.refreshControl?.endRefreshing()
                    self?.isEmpty = true
                    if (self?.loaded == false) {
                        self?.collectionView.emptyView(image: "warning", text: "Something went wrong.\n Pull down to retry.", dataCount: 0, emptyViewType: .main)
                    }
                }
                
            }
        }
        
        self.viewModel?.generateAPIToken()
    }
    
    override func setUpView() {
        self.view.addSubview(sideMenuView)
        self.sideMenuView.vc = self
        sideMenuView.frame = self.view.bounds
    }
    
    func onClickShowView(type: Int) {
        switch type {
        case 1:
            coordinator?.showBase2ndViewController()
        default: break
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section  == 0 {
              guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: mainHeaderId, for: indexPath) as? HomeHeaderCollectionViewCell else {
                  return UICollectionReusableView()
              }
              header.maintainingBalance.text = "\(self.homeData?.balance ?? "0.00") PHP"
              header.delegate = self
              return header
        }
            
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCollectionViewCell else {
                 return UICollectionReusableView()
             }
        header.label.text = section == 1 ? "Services Available" : section == 2 ?  "News" : section == 3 ?  "Pending Transactions" : "Transaction History"
        if section != 0 && section != 1{
            header.addAction()
            header.rightBtn.text = "View All"
        }else {
            header.rightBtn.isUserInteractionEnabled = true
            header.rightBtn.isHidden = true
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = section == 3 ? (self.homeData?.pendingTransaction?.count ?? 0 > 0 ? 40 : 0) : 40
        return CGSize(width:view.frame.width, height: section == 0 ? 240 : CGFloat(height))
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  self.homeData == nil ? 1 : 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  section == 0 ? 0 : 1
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(" INDEX : \(indexPath.section)")
//        let refresh = isRefreshing ? 1 : 0
        switch indexPath.section{
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as? ServicesCollectionViewCell else {return UICollectionViewCell()}
            cell.setUpCollectionView()
            cell.servicesData = servicesData
            cell.delegate = self
            return cell
        case 2 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as? NewsCollectionViewCell else {return UICollectionViewCell()}
            cell.delegate = self
            cell.setUpCollectionView()
            cell.newsData = newsData
            return cell
        case 3 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as? PendingTransactionCollectionViewCell else {return UICollectionViewCell()}
            cell.delegate = self
            cell.setUpCollectionView()
            cell.pTransactionsData = pTransactionData
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId4, for: indexPath) as? TransactionHistoryCollectionViewCell else {return UICollectionViewCell()}
            cell.setUpCollectionView()
            cell.section = 4
            cell.tHistoryData = tHistoryData
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let servicesHeight = ((self.servicesData.count / 3) * 95) // cell 80 for 40 + 10 , 20 + 10 , collection top 10 space , left and right 10 , bottom have space 10 
        let newsHeight = indexPath.section == 3 ? (self.homeData?.pendingTransaction?.count ?? 0 > 0 ? 190 : 1) : 190
        let tHistoryHeight = self.homeData?.transactionHistory?.count ?? 0 > 0 ? (80 * (self.homeData?.transactionHistory?.count ?? 0)) : 80
        let vheight = indexPath.section == 1 ? servicesHeight : (indexPath.section == 4 ? tHistoryHeight : newsHeight)
        
        return CGSize(width: collectionView.frame.width, height: CGFloat(vheight))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: section == 0 ? 0 : (section == 3 ? (self.homeData?.pendingTransaction?.count ?? 0 > 0 ? 10 : 0 ): 10), right: 0)
    }
    
}
//MENU
extension HomeViewController : HomeHeaderCollectionViewCellDelegate {
    func onClickMenu(cell: HomeHeaderCollectionViewCell) {
        sideMenuView.userData = self.homeData?.customer
        sideMenuView.updateSideMenu(width: sideMenuView.isShowMenu ? 0 : 250)
    }
}


extension HomeViewController : CollectionViewCellDelegate {
    func onClickShowView(cell: UICollectionViewCell, type: Int, index: Int) {
        if let itemCell = cell as? ServicesCell {
            print("SERVICES : \(servicesData[index])")
            switch servicesData[index].id {
            case 1:
                self.coordinator?.showLoadWalletViewController()
            case 2:
                self.coordinator?.showLoadWalletViewController(type: 1)
            case 3:
                self.coordinator?.showLoadWalletViewController()
            case 4:
                self.coordinator?.ShowELoadViewController()
//            case 4:
//            case 5:
//            case 6:
//            case 7:
//            case 8:
//            case 9:
            default:
                break
            }
            
        }else if let itemCell = cell as? NewsCell {
            print("NEWS : \(self.homeData?.news?[index])")
            self.coordinator?.showBase2ndViewController()
        }else if let itemCell = cell as? PendingTransactionCell {
            print("PENDING TRANSACTIONS : \(self.homeData?.pendingTransaction?[index])")
            self.coordinator?.showBase2ndViewController()
        }else {
            print("TRANSACTION HISTORY : \(self.homeData?.transactionHistory?[index])")
            self.coordinator?.showBase2ndViewController()
        }
    }
}
