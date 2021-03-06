//
//  NationalityViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class NationalityViewController: BaseViewControler, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  data?.nationals.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? NationalityCell else {
            return UICollectionViewCell()
        }
        cell.label.text = self.data?.nationals[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.parentView as? SignUpViewController {
            vc.nationalitySelected = self.data?.nationals[indexPath.item] ?? ""
        }
        if let vc = self.parentView as? ProfileViewController {
            vc.nationalitySelected = self.data?.nationals[indexPath.item] ?? ""
        }
        self.dismiss(animated: false) {
            self.hideModal()
        }
    }
    
    let cellId = "Cell ID"
    var data : Nationality? {
        didSet {
            
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
        setUpView()
        collectionView.register(NationalityCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    func hideModal() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    override func setUpView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(view).multipliedBy(0.8)
        }
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }

    }
    
    
}
