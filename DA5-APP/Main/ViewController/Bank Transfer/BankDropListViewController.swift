//
//  BankDropListViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/13/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class BankDropListViewController<T:Decodable>: BaseViewControler, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = self.data?[indexPath.item] as? BankListData {
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BankDropListCell else {
                return UICollectionViewCell()
            }
            cell.label.text = item.bank
            
            return cell
        }
        
        if let item = self.data?[indexPath.item] as? BankAccountLocalData {
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as? BankAccountDropListCell else {
                  return UICollectionViewCell()
            }
//            cell.bank.labelName.text = "Bank"
//            cell.bank.labelDesc.text = item.bank
//            cell.accountNo.labelName.text = "Account Number"
//            cell.accountNo.labelDesc.text = item.accountNumber
//            cell.accountName.labelName.text = "Account Name"
//            cell.accountName.labelDesc.text = item.accountName
            
            cell.label.text = "Bank Account"
            cell.bank.text = item.bank
            cell.accountNo.text = item.accountNumber
            cell.accountName.text = item.accountName
            cell.addBorders(edges: .bottom, color: ColorConfig().lightGray!, inset: 5, thickness: 0.5)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = self.data?[indexPath.item] as? BankAccountLocalData {
            return CGSize(width: collectionView.frame.width, height: 90)
        }
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.parentView as? BankTransferViewController {
//            vc.nationalitySelected = self.data.
            if let item = self.data?[indexPath.item] as? BankListData {
                vc.bankSelected = item
            }
            
            if let item = self.data?[indexPath.item] as? BankAccountLocalData {
//                 vc.bankSelected = item?[indexPath.item].bank
                vc.accountSelected = item
            }
        }
        self.dismissView()
    }
    var height : CGFloat
    var width : CGFloat
    
    let cellId = "Cell ID"
    let cellId2 = "Cell ID2"
    var data : [T]? {
        didSet {
//            print("DATA RECEIVED :",self.data?.count )
            self.collectionView.emptyView(image: "", text: "No available list.", dataCount: self.data?.count ?? 0, emptyViewType: .secondary)
        }
    }
    
    var parentView : UIViewController?
    
    fileprivate let containerView : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .white
        return v
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .clear
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(BankDropListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(BankAccountDropListCell.self, forCellWithReuseIdentifier: cellId2)
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpView()
    }
    
    init(height: CGFloat, width : CGFloat) {
        self.height = height
        self.width = width
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
    }
   
    func showModal() {
//        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
            self.view.layoutIfNeeded()
//       }
    }
    
    @objc func hideModal() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissView(){
        self.dismiss(animated: false) {
            self.hideModal()
        }
    }
    
    override func setUpView() {
        let maxHeight : CGFloat = view.frame.height * 0.8
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(width)
            make.height.equalTo(height > maxHeight ? maxHeight : height)
        }
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        
        if (data?.count ?? 0) == 0 {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
            self.view.addGestureRecognizer(tap)
        }

    }
    
    
}
