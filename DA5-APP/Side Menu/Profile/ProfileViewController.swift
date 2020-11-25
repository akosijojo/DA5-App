//
//  ProfileViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class ProfileViewController: BaseHomeViewControler {
    var accountData : AccountData? {
        didSet {
            print("RECIEVED DATA ",accountData?.name ?? "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationBar()
    }
    
    override func setUpView() {
        
    }
}
