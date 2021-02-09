//
//  TransactionsFullViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class TransactionsFullViewController: BaseHomeViewControler {
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

    var data : [TransactionHistoryData]? {
        didSet {
            data = [TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: nil, walletTransfer: nil, fx: nil, instapay: Instapay(id: 0, customerID: 0, referenceNo: "dwa", status: 0, bankName: "dwad", amount: "dwd", senderRefID: "dwad", uuid: "dwa", ubpTranID: "Dwad", reversalUbpTranID: "dwad", coreRefID: "dawd", traceNo: "dwad", resultStatus: "Dwa", resultCode: "Dwad", resultMessage: "Dwad", tranRequestDate: "Dwawd", createdAt: "Dwad", updatedAt: "dwad")),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: nil, walletTransfer: nil, fx: nil, instapay: Instapay(id: 0, customerID: 0, referenceNo: "dwa", status: 0, bankName: "dwad", amount: "dwd", senderRefID: "dwad", uuid: "dwa", ubpTranID: "Dwad", reversalUbpTranID: "dwad", coreRefID: "dawd", traceNo: "dwad", resultStatus: "Dwa", resultCode: "Dwad", resultMessage: "Dwad", tranRequestDate: "Dwawd", createdAt: "Dwad", updatedAt: "dwad")),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: nil, walletTransfer: nil, fx: nil, instapay: Instapay(id: 0, customerID: 0, referenceNo: "dwa", status: 0, bankName: "dwad", amount: "dwd", senderRefID: "dwad", uuid: "dwa", ubpTranID: "Dwad", reversalUbpTranID: "dwad", coreRefID: "dawd", traceNo: "dwad", resultStatus: "Dwa", resultCode: "Dwad", resultMessage: "Dwad", tranRequestDate: "Dwawd", createdAt: "Dwad", updatedAt: "dwad")),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: Eload(id: 0, customerID: 0, referenceNo: "dwad", status: 0, phone: "Dwad", productAmount: "Dwad", productNetwork: "dwad", productName: "dwa", productCode: "Dwad", resultStatus: "Dawd", resultCode: "Dwad", resultMessage: "Dwad", transStatus: "Dwad", transactionDate: "Dwa", createdAt: "Dwad", updatedAt: "daw"), walletTransfer: nil, fx: nil, instapay:nil),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: Eload(id: 0, customerID: 0, referenceNo: "dwad", status: 0, phone: "Dwad", productAmount: "Dwad", productNetwork: "dwad", productName: "dwa", productCode: "Dwad", resultStatus: "Dawd", resultCode: "Dwad", resultMessage: "Dwad", transStatus: "Dwad", transactionDate: "Dwa", createdAt: "Dwad", updatedAt: "daw"), walletTransfer: nil, fx: nil, instapay:nil),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: Eload(id: 0, customerID: 0, referenceNo: "dwad", status: 0, phone: "Dwad", productAmount: "Dwad", productNetwork: "dwad", productName: "dwa", productCode: "Dwad", resultStatus: "Dawd", resultCode: "Dwad", resultMessage: "Dwad", transStatus: "Dwad", transactionDate: "Dwa", createdAt: "Dwad", updatedAt: "daw"), walletTransfer: nil, fx: nil, instapay:nil),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: nil, walletTransfer: nil, fx: nil, instapay: Instapay(id: 0, customerID: 0, referenceNo: "dwa", status: 0, bankName: "dwad", amount: "dwd", senderRefID: "dwad", uuid: "dwa", ubpTranID: "Dwad", reversalUbpTranID: "dwad", coreRefID: "dawd", traceNo: "dwad", resultStatus: "Dwa", resultCode: "Dwad", resultMessage: "Dwad", tranRequestDate: "Dwawd", createdAt: "Dwad", updatedAt: "dwad")),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: nil, walletTransfer: nil, fx: nil, instapay: Instapay(id: 0, customerID: 0, referenceNo: "dwa", status: 0, bankName: "dwad", amount: "dwd", senderRefID: "dwad", uuid: "dwa", ubpTranID: "Dwad", reversalUbpTranID: "dwad", coreRefID: "dawd", traceNo: "dwad", resultStatus: "Dwa", resultCode: "Dwad", resultMessage: "Dwad", tranRequestDate: "Dwawd", createdAt: "Dwad", updatedAt: "dwad")),TransactionHistoryData(id: 0, customerID: 0, referenceNo: "dawd", status: 0, type: 0, createdAt: "awdaw", updatedAt: "dawdw", cashInOut: nil, eload: nil, walletTransfer: nil, fx: nil, instapay: Instapay(id: 0, customerID: 0, referenceNo: "dwa", status: 0, bankName: "dwad", amount: "dwd", senderRefID: "dwad", uuid: "dwa", ubpTranID: "Dwad", reversalUbpTranID: "dwad", coreRefID: "dawd", traceNo: "dwad", resultStatus: "Dwa", resultCode: "Dwad", resultMessage: "Dwad", tranRequestDate: "Dwawd", createdAt: "Dwad", updatedAt: "dwad"))
            ]
                
            self.collectionView.reloadData()
            self.collectionView.emptyView(image: "", text: "You currently have no transactions", dataCount: data?.count ?? 0, emptyViewType: .secondary)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerCell)
        collectionView.register(TransactionHistoryCell.self, forCellWithReuseIdentifier: cellId)
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
        isRefreshing = true
        isAppend = false
        self.viewModel?.getAllTransactionHistory(page: 0, token: self.coordinator?.token)
        refreshControl?.endRefreshing()
       
    }

    @objc func requestNewData() {
         isAppend = true
         self.viewModel?.getAllTransactionHistory(token: self.coordinator?.token)
         refreshControl?.endRefreshing()
     }

    func getData() {
        self.viewModel?.onSuccessTransactionsList = { [weak self] data in
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
            DispatchQueue.main.async {
                //MARK: - stop animation
                self?.stopAnimating()
                self?.isRefreshing = false // to trigger bottom refresh
            }
        }
        
        self.viewModel?.onErrorHandling = { [weak self] data in
             DispatchQueue.main.async {
                //MARK: - stop animation
                self?.stopAnimating()
                self?.isRefreshing = false // to trigger bottom refresh
            }
        }
        
        self.setAnimate(msg: "Please wait...")
        self.viewModel?.getAllTransactionHistory(token: self.coordinator?.token)
        
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


extension TransactionsFullViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? HeaderCell else {
             return UICollectionReusableView()
         }
        header.headerView.title.text = "Successful Transactions"

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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TransactionHistoryCell else {
            return UICollectionViewCell()
        }
        cell.data = self.data?[indexPath.item]
//        cell.delegate = self
        cell.bottomLine.isHidden = true
        cell.index = indexPath.item
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height : CGFloat = 80 + checkIfBankTransferOrWalletTransfer(index: indexPath.item)
        return CGSize(width: collectionView.frame.width - 40, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == ((self.data?.count ?? 0) - 1) {
            // loadMoreData()
            if !isRefreshing {
                isRefreshing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.requestNewData()
                }
            }
        }
    }
    
    func checkIfBankTransferOrWalletTransfer(index: Int) -> CGFloat {
        return self.data?[index].instapay != nil || self.data?[index].walletTransfer != nil ? 20 : 0
    }

}
