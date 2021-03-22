//
//  NewsFullListViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/22/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class NewsFullListViewController: BaseHomeViewControler {
    var headerCell = "headerCell"
    var cellId = "cellId"
    
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
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerCell)
        collectionView.register(PendingListCell.self, forCellWithReuseIdentifier: cellId)
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
        self.viewModel?.getPendingTransactions(page: 0, token: self.coordinator?.token)
        refreshControl?.endRefreshing()
       
    }
    
    @objc func requestNewData() {
         isAppend = true
         self.viewModel?.getPendingTransactions(token: self.coordinator?.token)
         refreshControl?.endRefreshing()
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


extension NewsFullListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as? HeaderCell else {
             return UICollectionReusableView()
         }
        header.headerView.title.text = "All News"

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
              if !isRefreshing {
                 isRefreshing = true
                 self.requestNewData()
              }
          }
    }
}
