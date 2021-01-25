//
//  PendingTransactionFullViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class PendingTransactionFullViewController: BaseHomeViewControler {
    var headerCell = "headerCell"
    var cellId = "cellId"
    var loaderCellId = "LoaderId"
    
    var viewModel : HomeFullListViewModel?
    
    var refreshControl : UIRefreshControl?
    var isRefreshing  : Bool = false
    var canRequest : Bool = true
    
    var isAppend : Bool = false
    
    lazy var collectionView : UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
      v.bounces = true
      v.showsHorizontalScrollIndicator = false
      v.backgroundColor = ColorConfig().white
     return v
    }()
    
    var data : [PendingTransactionsData]? {
        didSet {
            print("RELOADING NEW DATA")
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerCell)
        collectionView.register(PendingListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(BottomLoaderCell.self, forCellWithReuseIdentifier: loaderCellId)
        setUpView()
        getData()
        setUpRefreshView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
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
    
    @objc func refreshData() {
        print("REFRESHING ? ")
        isRefreshing = true
        isAppend = false
        self.viewModel?.getPendingTransactions(page: 0, token: self.coordinator?.token)
        refreshControl?.endRefreshing()
       
    }
    
    @objc func requestNewData() {
         isAppend = true
         print("REFRESHING Bottom? ")
         self.viewModel?.getPendingTransactions(token: self.coordinator?.token)
         refreshControl?.endRefreshing()
     }
     

    
    func getData() {
        self.viewModel?.onSuccessPendingList = { [weak self] data in
          print("DATA RECEIVED")
            DispatchQueue.main.async {
                if self?.isAppend == true {
                    if let response = data {
                        self?.data?.append(contentsOf: response)
                    }
                }else {
                    self?.data = data
                }
                
                //MARK: - stop animation
                self?.stopAnimating()
                // MARK: - to restrict request when the data didnt reach the max limit
                if data?.count != 10 {
                    self?.isRefreshing = true // to restrict request
                }else {
                    self?.isRefreshing = false // to trigger bottom refresh
                }
            }
          
        }
        
        self.viewModel?.onSuccessRequest = { [weak self] data in
           print("DATA RECEIVED")
            DispatchQueue.main.async {
                //MARK: - stop animation
                if data?.tag == 2 {
                    self?.showAlert(buttonOK: "Ok", message: "Transaction cancelled", actionOk: nil, completionHandler: nil)
                }
                
                self?.stopAnimating()
                self?.isRefreshing = false // to trigger bottom refresh
            }
        }
        
        self.viewModel?.onErrorHandling = { [weak self] data in
           print("ERROR DATA RECEIVED")
             DispatchQueue.main.async {
                //MARK: - stop animation
                self?.showAlert(buttonOK: "Ok", message: data?.message ?? "Something went wrong", actionOk: nil, completionHandler: nil)
                self?.stopAnimating()
                self?.isRefreshing = false // to trigger bottom refresh
            }
        }
        
        self.setAnimate(msg: "Please wait...")
        self.viewModel?.getPendingTransactions(token: self.coordinator?.token)
        
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


extension PendingTransactionFullViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? HeaderCell else {
             return UICollectionReusableView()
         }
        header.headerView.title.text = "Pending Transactions"

         return header
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.width, height:80)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.data?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PendingListCell else {
            return UICollectionViewCell()
        }
        cell.data = self.data?[indexPath.item]
        cell.delegate = self
        cell.index = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == ((self.data?.count ?? 0) - 1) {
            // loadMoreData()
            if !isRefreshing {
                print("REFRESHING BOTTOM")
                isRefreshing = true
                self.requestNewData()
            }
        }
    }

}

extension PendingTransactionFullViewController : PendingListCellDelegate {
    func onClick(cell: PendingListCell, data: PendingTransactionsData?) {
         self.showAlert(buttonOK: "Ok", buttonCancel: "Cancel", title: "", message: "Are you sure you want to cancel?", actionOk: { (action) in
                              
            if let ref = data?.referenceNo {
                var type : Int = data?.cashInOut != nil ? (data?.cashInOut?.type ?? 0) : data?.fx != nil ? 4 : 0
            
                self.viewModel?.declineTransaction(referenceNo: ref, type: "\(type)" , token: self.coordinator?.token)
                    self.data?.remove(at: cell.index)
                    self.collectionView.reloadData()
             }
           
                     
          }, actionCancel: nil, completionHandler: nil)
        print("REFERENCE NO. \(data?.referenceNo)")
    }
}


//extension PendingTransactionFullViewController : LoadWalletCellDelegate {
//    func onClickItem(cell: LoadWalletCell, index: Int) {
//        print("CLICKING")
//        self.coordinator?.showCashInViewController(data: self.data?[index],type: type)
//    }
//
//}
