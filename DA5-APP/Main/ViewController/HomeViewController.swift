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
                NewsData(id: 1, name: "RDS signs with Direct Agent 5, Inc.", image: "https://da5.com.ph/h/wp-content/uploads/2020/09/RDS-DA5005transparent-400x250-1.png" ,desc: "Robinsons Department Store (RDS) gives shoppers the value of utmost convenience by letting them complete multiple transactions in a safe, secure and comfortable environment. Customers enjoy a more practical and multi-tasking visit to the Robinsons Business Center, which offers bills payment, foreign exchange, show and concert tickets, airline bookings and payments, and telco prepaid products.\n\nThe latest company to sign up with Robinsons Department Store is Direct Agent 5, Inc. (DA5), an authorized direct agent of Western Union Money Transfer. DA5 started as a money remittance agent with a handful of locations, which has grown to over 1,000 company-owned and partner locations nationwide.\n\n“This partnership will strategically bring the Western Union services to all business centers of Robinsons Department Stores nationwide. Both companies are looking into not just servicing mall-goers, but more so, Filipino families who are recipients of OFW remittances.” DA5 CEO & President Raymond A. Babst notes the ultimate goal of their partnership. The DA5 family continues to strive in delivering worthwhile services to empower Filipino communities, both locally and abroad."),
                NewsData(id: 2, name: "Direct Agent 5, Inc.", image: "https://da5.com.ph/h/wp-content/uploads/2020/07/DA5-400x250transparent.png", desc: "Direct Agent 5, Inc. (DA5) is one of the leading authorized direct agents of Western Union in the Philippines. Since its birth in 2006 with only a handful of staff, DA5 has grown to accommodate a family of services including bills payment and prepaid card retailing.\n\nWhile DA5’s efforts have been honored by Western Union since its first year of operation, the company recognizes that its laurels are not the plaques and certificates it has received, rather it is the countless dreams of fellow Filipinos they helped realize over the years."),
                NewsData(id: 3, name: "RD Pawnshop signs with DA5", image: "https://da5.com.ph/h/wp-content/uploads/2020/09/RD-DA5.png", desc: "From left RDPI Chief Operation Officer, Helen Nograles, RD Corporation Vice Chairman Ritche Rivera, DA5 CEO & President Raymond Babst, DA5 Vice President for Business Development Edward Estacion, DA5 Compliance Manager, Atty. Mary Rose Rebadulla.\n\nDirect Agent 5, Inc. (DA5), an authorized agent of Western Union®, is proud to announce its collaboration with RD Pawnshop Inc., a company engaged in pawning, cash padala, e-loading, NSO/PSA payments, insurance and bills payment.\n\n“DA5 is proud to collaborate with RD Pawnshop in expanding the Western Union service network to around one thousand five hundred RD Pawnshop branches nationwide by year end. Both companies are excited to offer this service to more Filipino families who are recipients of OFW remittances. Our goal is to provide fast, reliable and convenient money transfer service to meet the needs of people across the country.” DA5 CEO & President Raymond A. Babst notes the main goal of their partnership. With this collaboration, DA5 will have a combined network of more than two thousand five hundred company-owned and partner locations servicing the Filipino OFWs nationwide.\n\n In adherence to a paramount core value of providing outstanding service guided by Christian principles, President of RDPI Mr. Ritche C. Rivera has this message for both RDPI and DA5, “Brethren we are just stewards of all the material gain and wealth, let us give to God all the credits”.\n\nThe earth is the LORD‘s, and the fullness thereof; the world, and they that dwell therein.–\n\nPsalm 24:1 KJV"),
            ]
                
            self?.servicesData = [
                ServicesData(id: 1, name: "Load Wallet", image: "digital-wallet"),
                ServicesData(id: 2, name: "Cash Out", image: "atm"),
                ServicesData(id: 3, name: "Bank Transfer", image: "bank-transfer"),
                ServicesData(id: 4, name: "Send Money", image: "money"),
                ServicesData(id: 5, name: "FX", image: "exchange"),
                ServicesData(id: 6, name: "Pay Bills", image: "bill"),
                ServicesData(id: 7, name: "Buy Load", image: "smartphone"),
                ServicesData(id: 8, name: "Crypto", image: "crypto"),
                ServicesData(id: 9, name: "Loans", image: "loan"),
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
        header.label.text = section == 1 ? "Services Available" : section == 2 ?  "News" : section == 3 ?  "Pending Transactions" : "Transaction Successful"
        
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
            self.coordinator?.showNewsItem(data: self.homeData?.news?[index])
        }else if let itemCell = cell as? PendingTransactionCell {
//            print("PENDING TRANSACTIONS : \(self.homeData?.pendingTransaction?[index])")
//            self.coordinator?.showBase2ndViewController()
        }else {
//            print("TRANSACTION HISTORY : \(self.homeData?.transactionHistory?[index])")
//            self.coordinator?.showBase2ndViewController()
        }
    }
    
    
}
