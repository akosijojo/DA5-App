//
//  BaseSecondaryViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class BaseSecondaryViewController: BaseHomeViewControler {
    var centerLbl : UILabel = {
       let v = UILabel()
        v.text = "Coming Soon"
        v.font = UIFont(name: Fonts.bold, size: 18)
        v.textAlignment = .center
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func setUpView() {
        view.addSubview(centerLbl)
        centerLbl.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(100)
        }
    }
}

