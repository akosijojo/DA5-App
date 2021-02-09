//
//  DropDownViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/18/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit


struct DropItem : Decodable {
    var key : String
    var value : String
}


class DropDownCell: UICollectionViewCell{
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont(name: Fonts.medium, size: 12)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.bottom.equalTo(self)
        }
        
    }
}


class DropDownViewController<T:Decodable>: BaseViewControler, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? DropDownCell else {
            return UICollectionViewCell()
        }
        
        if let d = self.data?[indexPath.item] as? String {
            cell.label.text = d
        }
        
        if let d = self.data?[indexPath.item] as? DropItem {
            cell.label.text = d.key
        }
               
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.parentView as? FXViewController {
    //            vc.nationalitySelected = self.data.
            if let d = self.data?[indexPath.item] as? String {
                vc.selectedCurrency = d
            }
        }
        if let vc = self.parentView as? PaybillsSelectedItemViewController {
            //RETURN SELECTED ITEM
            if let item = self.data?[indexPath.item] as? DropItem {
                 vc.dropItemSelected = item
            }
        }
        self.dismiss(animated: false) {
            self.hideModal()
        }
    }

    let cellId = "Cell ID"
    var mainFrame : CGSize = CGSize(width: 0, height: 0)
    
    var data : [T]? {
        didSet {
//            print("DATA RECEIVED :",self.data?.count )
        }
    }
    
    var parentView : UIViewController?

    lazy var BackDropView : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .clear
        return v
    }()
    
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
        setUpView()
        collectionView.register(DropDownCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    init(width: CGFloat, height : CGFloat) {
        super.init(nibName: nil, bundle: nil)
        mainFrame = CGSize(width: width, height: height)
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
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        self.view.layoutIfNeeded()
    }

    func hideModal() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0)
            self.view.layoutIfNeeded()
        }
    }

    override func setUpView() {
        view.addSubview(BackDropView)
        BackDropView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(mainFrame.width)
            make.height.equalTo(mainFrame.height)
        }
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideModalOnClick))
        self.BackDropView.isUserInteractionEnabled = true
        self.BackDropView.addGestureRecognizer(tap)
    }
    
    @objc func hideModalOnClick() {
//        print("Dismiss Drop")
        self.dismiss(animated: false) {
           self.hideModal()
        }
    }
}
