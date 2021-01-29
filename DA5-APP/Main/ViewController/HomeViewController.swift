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
    
    var referenceNo : String = ""
    
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
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl!)
        }
    }
    
    @objc func declineTransaction(refNo: String, type: String) {
        self.viewModel?.declineTransaction(referenceNo: refNo,type: type)
    }
    
    func removeTransaction(refNo: String) {
        print("REMOVING : \(refNo)")
        if let pTransaction = self.homeData?.pendingTransaction {
            print("REMOVING 2: \(pTransaction)")
            for index in 0...pTransaction.count - 1  {
                print("REMOVING 3: \(index)")
                if pTransaction[index].referenceNo == refNo {
                    print("REMOVING 4: \(pTransaction[index].referenceNo)")
                    if let item = self.homeData?.pendingTransaction?[index].convertToHistory(){
                          self.homeData?.transactionHistory?.insert(item, at: index)
                    }
                    self.homeData?.pendingTransaction?.remove(at: index)
                    self.collectionView.reloadData()
                }
            }
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
                 NewsData(id: 2, name: "City", image: "app_logo"),
                 NewsData(id: 3, name: "Western", image: "western"),
                 NewsData(id: 4, name: "Western", image: "western"),
            ]
                
            self?.servicesData = [
                ServicesData(id: 1, name: "Load Wallet", image: "digital-wallet"),
                ServicesData(id: 2, name: "Cash Out", image: "atm"),
                ServicesData(id: 3, name: "Bank Transfer", image: "bank-transfer"),
                ServicesData(id: 4, name: "Wallet transfer", image: "money"),
                ServicesData(id: 5, name: "FX", image: "exchange"),
                ServicesData(id: 6, name: "Pay Bills", image: "bill"),
                ServicesData(id: 7, name: "Buy Load", image: "smartphone"),
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
        
       self.viewModel?.onSuccessLogout = { [weak self] status in
            DispatchQueue.main.async {
                self?.coordinator?.logInCoordinator(didLogout: true)
            }
        }
        
        self.viewModel?.onSuccessGenerateToken = { [weak self] data in
            DispatchQueue.main.async {
                self?.coordinator?.token = data?.accessToken
                self?.coordinator?.updateToken(data: data)
                self?.viewModel?.getHomeData(id: UserLoginData.shared.id ?? 0) //self?.customerData?.id ?? 0
            }
        }
        
        self.viewModel?.onSuccessUpdateToken = { [weak self] data in
            DispatchQueue.main.async {
                self?.coordinator?.token = data?.accessToken
                self?.coordinator?.updateToken(data: data)
                //self?.customerData?.id ?? 0
            }
        }
            
        self.viewModel?.onSuccessRequest = { [weak self] status in
           DispatchQueue.main.async {
            //MARK: - 1 = DECLINE TRANSACTION
            print("REMOVING MODEL : \(self?.referenceNo) == \(status?.tag)")
               if status?.tag == 2 {
                    if let ref = self?.referenceNo {
                         self?.removeTransaction(refNo: ref)
                    }
               }
           }
        }
                
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
               //MARK: - 1 = ERROR LOADING HOME DATA
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
    
//    func onClickShowView(type: Int) {
//        switch type {
//        case 1:
//            coordinator?.showBase2ndViewController(title: <#String#>)
//        default: break
//            
//        }
//    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        if section  == 0 {
              guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: mainHeaderId, for: indexPath) as? HomeHeaderCollectionViewCell else {
                  return UICollectionReusableView()
              }
              header.maintainingBalance.text = "PHP \(self.homeData?.balance ?? "0.00")"
              header.delegate = self
              return header
        }
            
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCollectionViewCell else {
                 return UICollectionReusableView()
             }
        header.label.text = section == 1 ? "Services Available" : section == 2 ?  "News" : section == 3 ?  "Pending Transactions" : "Transaction History"
        
        header.index = section
        if section != 0 && section != 1{
            header.addAction()
            header.rightBtn.text = "View All"
        }else {
            header.rightBtn.isUserInteractionEnabled = true
            header.rightBtn.isHidden = true
        }
        header.delegate = self
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
            cell.tHistoryData = tHistoryData
            cell.setUpCollectionView()
            cell.section = 4
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let servicesHeight = ((self.servicesData.count / 3) * 95) // cell 80 for 40 + 10 , 20 + 10 , collection top 10 space , left and right 10 , bottom have space 10 
        let newsHeight = indexPath.section == 3 ? (self.homeData?.pendingTransaction?.count ?? 0 > 0 ? 190 : 1) : 190
        let tHistoryHeight = (self.homeData?.transactionHistory?.count ?? 0 > 0 ? (100 * (self.homeData?.transactionHistory?.count ?? 0)) : 80 ) + checkIfBankTransferOrWalletTransfer()
        let vheight = indexPath.section == 1 ? servicesHeight : (indexPath.section == 4 ? tHistoryHeight : newsHeight)
        
        return CGSize(width: collectionView.frame.width, height: CGFloat(vheight))
    }

    func checkIfBankTransferOrWalletTransfer() -> Int {
        if let transactions = self.homeData?.transactionHistory {
            var height : Int = 0
            for data in transactions {
                if data.instapay != nil || data.walletTransfer != nil {
                    height += 20
                }
            }
            return height
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: section == 0 ? 0 : (section == 3 ? (self.homeData?.pendingTransaction?.count ?? 0 > 0 ? 10 : 0 ): 10), right: 0)
    }
    
}
//MENU
extension HomeViewController : HomeHeaderCollectionViewCellDelegate, HeaderCollectionViewCellDelegate {
    func onClickViewAll(cell: HeaderCollectionViewCell, index: Int) {
        switch index {
        case 2:
            self.coordinator?.showNewsFullList()
        case 3:
            self.coordinator?.showPendingTransactionFullList()
        case 4:
            self.coordinator?.showTransactionHistoryFullList()
        default:
            break;
        }
    }
    
    func onClickMenu(cell: HomeHeaderCollectionViewCell) {
        sideMenuView.userData = self.homeData?.customer
        sideMenuView.updateSideMenu(width: sideMenuView.isShowMenu ? 0 : 250)
    }
}


extension HomeViewController : CollectionViewCellDelegate {
    func removeItem(cell: UICollectionViewCell, index: Int) {
        //MARK: - REMOVE TRANSACTION
        self.showAlert(buttonOK: "Ok", buttonCancel: "Cancel", title: "", message: "Are you sure you want to cancel?", actionOk: { (action) in
            
            if let ref = self.homeData?.pendingTransaction?[index].referenceNo {
                self.referenceNo = ref
                let type = self.homeData?.pendingTransaction?[index].cashInOut != nil ? self.homeData?.pendingTransaction?[index].type : 4
                self.declineTransaction(refNo: ref,type: "\(type ?? 0)")
//                if let cc = cell as? CollectionViewCell {
//                    cc.collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
//                }
            }
           
        }, actionCancel: nil, completionHandler: nil)
    }
    
    func onClickShowView(cell: UICollectionViewCell, type: Int, index: Int) {
        if let itemCell = cell as? ServicesCell {
            print("SERVICES : \(servicesData[index])")
            switch servicesData[index].id {
            case 1:
                self.coordinator?.showLoadWalletViewController()
            case 2:
                self.coordinator?.showLoadWalletViewController(type: 1)
            case 3:
                self.coordinator?.showBankTransferViewController()
            case 4:
                self.coordinator?.showWalletTransferViewController()
            case 5:
                self.coordinator?.showFxViewController(balance: self.homeData?.balance)
            case 6:
//                self.coordinator?.showBase2ndViewController(title: "Paybills")
                self.coordinator?.showPaybillsViewController()
            case 7:
                self.coordinator?.ShowELoadViewController()
            case 8:
                 self.coordinator?.showBase2ndViewController(title: "Crypto")
            case 9:
                self.coordinator?.showBase2ndViewController(title: "Loans")
            default:
                break
            }
            
        }else if let itemCell = cell as? NewsCell {
//            print("NEWS : \(self.homeData?.news?[index])")
            self.coordinator?.showNewsItem()
        }else if let itemCell = cell as? PendingTransactionCell {
//            print("PENDING TRANSACTIONS : \(self.homeData?.pendingTransaction?[index])")
//            self.coordinator?.showBase2ndViewController()
        }else {
//            print("TRANSACTION HISTORY : \(self.homeData?.transactionHistory?[index])")
//            self.coordinator?.showBase2ndViewController()
        }
    }
    
    
}
