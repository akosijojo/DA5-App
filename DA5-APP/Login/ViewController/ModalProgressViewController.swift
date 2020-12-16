//
//  ModalProgressViewController.swift
//  DA5-APP
//
//  Created by Jojo on 12/3/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class ModalProgressViewController: BaseViewControler{
    var parentView : UIViewController?
    
    lazy var containerView : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .white
        return v
    }()

    lazy var mainLabel : UILabel = {
        let v = UILabel()
        return v
    }()
    
    lazy var loadingView : UILabel = {
      let v = UILabel()
      return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func getData() {
        
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
    }
    
    
}

class TopProgressViewController: BaseViewControler{
    var parentView : UIViewController?
    
    lazy var containerView : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
//        v.backgroundColor = .white
        return v
    }()

    lazy var mainLabel : UILabel = {
        let v = UILabel()
        return v
    }()
    
    lazy var loadingView : UILabel = {
      let v = UILabel()
      return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func getData() {
        
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
//            self.view.backgroundColor = UIColor(white: 0, alpha: 0)
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
            make.centerX.equalTo(view)
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.width.equalTo(250)
            make.height.equalTo(view).multipliedBy(0.8)
        }
    }
    
    
}
